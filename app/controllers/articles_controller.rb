class ArticlesController < ApplicationController
  def index
    articles = Article.recent
    render json: articles
  end

  def show
  end

  def serializer
    ArticleSerializer
  end
end
