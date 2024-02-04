class Selection < ActiveRecord::Base
  belongs_to :user
  belongs_to :draft

  # factions including those from expansions
  enum :faction => %i[arborec barony_of_letnev clan_of_saar empyrean ghosts_of_creuss emirates_of_hacan]

  validates :faction, presence: true
  validates :user_id, presence: true
  validates :draft_id, presence: true
end