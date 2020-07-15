class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: [:index, :show]

  def index
    paginated = Article.recent.page(current_page).per(per_page)
    options = PaginationMetaGenerator.new(request: request, total_pages: paginated.total_pages).call()
    render json: ArticleSerializer.new(paginated, options)
  end

  def show
    article = Article.find(params[:id])
    render json: ArticleSerializer.new(article)
  end

  def create

  end

  private

  def current_page
    (params[:page] || 1).to_i
  end

  def per_page
    (params[:per_page] || 20).to_i
  end
end
