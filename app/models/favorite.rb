class Favorite < ActiveRecord::Base
  attr_accessible :post
  belongs_to :post
  belongs_to :user
  # attr_accessible :title, :body
end
