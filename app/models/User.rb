class User < ActiveRecord::Base

  has_and_belongs_to_many :drafts, :join_table => :user_drafts
  has_many :selections

  before_create :set_token

  validates :name, presence: true, uniqueness: true
  validates :password, presence: true

 
  def set_token
    self.token = SecureRandom.hex
  end
end