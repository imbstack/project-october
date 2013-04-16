class Comment < ActiveRecord::Base
  acts_as_nested_set :scope => :post

  attr_accessible :body, :parent_id, :post_id

  belongs_to :post
  belongs_to :user

  validates_presence_of :post, :user, :body
end
