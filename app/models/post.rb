class Post < ActiveRecord::Base
  attr_accessible :body, :title, :topic, :image
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  belongs_to :user
  belongs_to :topic
  after_create :create_vote

  mount_uploader :image, ImageUploader

  default_scope order('rank DESC') 
  scope :visible_to, lambda { |user| user ? scoped : joins(:topic).where('topics.public' => true) }

  def up_votes
    self.votes.where(value: 1).count
  end

  def down_votes
    self.votes.where(value: -1).count
  end

  def points
    self.votes.sum(:value).to_i
  end

  def update_rank
    age = (self.created_at - Time.new(1970,1,1)) / 86400
    new_rank = points + age

    self.update_attribute(:rank, new_rank)
  end

  validates :title, length: { minimum: 5}, presence: true
  validates :body, length: { minimum: 20 }, presence: true
  validates :topic, presence: true
  validates :user, presence: true

  private

  def create_vote
    self.user.votes.create(value: 1, post: self)
  end
end
