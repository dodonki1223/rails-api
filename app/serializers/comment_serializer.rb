class CommentSerializer < ApplicationSerializer
  attributes :id, :content, :user, :references
  has_one :artile
end
