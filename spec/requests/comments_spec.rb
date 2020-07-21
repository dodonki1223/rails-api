require 'rails_helper'

RSpec.describe "/comments", type: :request do
  let(:article) { create :article }
  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    subject { get article_comments_path(article.id), headers: valid_headers, as: :json }

    it "renders a successful response" do
      subject
      # expect(response).to be_successful この書き方だと詳しいエラーの内容がわからないため、
      # have_http_status を使用するとより鮮明にエラー内容を表示してくれる
      expect(response).to have_http_status(:ok)
    end

    it 'should return only comments belonging to article' do
      comment = create :comment, article: article
      create :comment
      subject
      expect(json_data.length).to eq(1)
      expect(json_data.first['id']).to eq(comment.id.to_s)
    end

    it 'should paginate results' do
      comments = create_list :comment, 3, article: article
      get article_comments_path(article.id), params: { per_page: 1, page: 2 }
      expect(json_data.length).to eq(1)
      comment = comments.second
      expect(json_data.first['id']).to eq(comment.id.to_s)
    end

    it 'should have proper json body' do
      comment = create :comment, article: article
      subject
      expect(json_data.first['attributes']).to eq({
        'content' => comment.content
      })
    end

    it 'should have related objects infomation in the response' do
      user = create :user
      create :comment, article: article, user: user
      subject
      relationships = json_data.first['relationships']
      expect(relationships['article']['data']['id']).to eq(article.id.to_s)
      expect(relationships['user']['data']['id']).to eq(user.id.to_s)
    end
  end

  describe "POST /create" do
    let(:valid_attributes) { { content: 'My awesome comment for article' } }
    let(:invalid_attributes) { { content: '' } }

    context 'when not authorized' do
      subject { post article_comments_path(article.id), as: :json }

      it_behaves_like 'forbidden_requests'
    end

    context 'when authorized' do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      let(:valid_headers) { { authorization: "Bearer #{access_token.token}" } }

      context "with valid parameters" do
        it "creates a new Comment" do
          expect {
            post article_comments_path(article.id),
                params: { comment: valid_attributes }, headers: valid_headers, as: :json
          }.to change(Comment, :count).by(1)
        end

        it "renders a JSON response with the new comment" do
          post article_comments_path(article.id),
              params: { comment: valid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Comment" do
          expect {
            post article_comments_path(article.id),
                params: { comment: invalid_attributes }, as: :json
          }.to change(Comment, :count).by(0)
        end

        it "renders a JSON response with errors for the new comment" do
          post article_comments_path(article.id),
              params: { comment: invalid_attributes }, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including("application/json"))
        end
      end

    end
  end
end
