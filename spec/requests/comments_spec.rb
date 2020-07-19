require 'rails_helper'

RSpec.describe "/comments", type: :request do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  let(:valid_headers) {
    {}
  }

  describe "GET /index" do
    let(:article) { create :article }

    it "renders a successful response" do
      get article_comments_path(article.id), headers: valid_headers, as: :json
      # expect(response).to be_successful この書き方だと詳しいエラーの内容がわからないため、
      # have_http_status を使用するとより鮮明にエラー内容を表示してくれる
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    let(:article) { create :article }

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
        expect(response.content_type).to eq("application/json")
      end
    end
  end
end
