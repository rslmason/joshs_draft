class UserDraft < ActiveRecord::Base
  belongs_to :user
  belongs_to :draft, foreign_key: :draft_id, class_name: "Draft"

  validates :user_id, presence: true, uniqueness: { scope: :draft_id }
  validates :draft_id, presence: true
end