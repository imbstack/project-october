class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  cattr_accessor :UP do true end
  cattr_accessor :DOWN do false end
end
