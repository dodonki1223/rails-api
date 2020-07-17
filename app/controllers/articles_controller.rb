class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: [:index, :show]

  def index
    paginated = Article.recent.page(current_page).per(per_page)
    options = PaginationMetaGenerator.new(request: request, total_pages: paginated.total_pages).call()
    render json: ArticleSerializer2.new(paginated, options)
  end

  def show
    article = Article.find(params[:id])
    render json: ArticleSerializer2.new(article)
  end

  def create
    article = Article.new(article_params)
    article.save!
    render json: article, status: :created
  rescue
    render json: article, adapter: :json_api, 
    serializer: ErrorSerializer,
    status: :unprocessable_entity      
  end

  def update

  end

  private

  def current_page
    (params[:page] || 1).to_i
  end

  def per_page
    (params[:per_page] || 20).to_i
  end

  def article_params
    # パラメータから data の attributes を取得し許可するのは `title`, `content`, `slug` のみとする
    # パラメータが存在しなかったら `空のパラメータ` を返す
    params.require(:data).require(:attributes).
      permit(:title, :content, :slug) ||
    ActionController::Parameters.new
  end
end
