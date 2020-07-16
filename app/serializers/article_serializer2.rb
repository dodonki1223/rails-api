class ArticleSerializer2 < ApplicationSerializer
  set_type :articles
  attributes :title, :content, :slug
end
