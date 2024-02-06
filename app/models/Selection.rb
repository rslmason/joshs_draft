class Selection < ActiveRecord::Base
  belongs_to :user
  belongs_to :draft

  # factions including those from expansions
  enum :faction => %i[
    argent_flight
    arborec 
    barony_of_letnev 
    clan_of_saar 
    embers_of_muaat
    emirates_of_hacan
    empyrean 
    federation_of_sol
    ghosts_of_creuss 
    l1z1x_mindnet
    mahact_gene_sorcerers
    mentak_coalition
    naalu_collective
    naaz-rhoka_alliance
    nekro_virus
    nomad
    sardaak_n'orr
    titans_of_ul
    universities_of_jol_nar
    vuil'raith_cabal
    winnu
    xxcha_kingdom
    yin_brotherhood
    yssaril_tribe
  ]

  validates :faction, inclusion: { in: factions.keys }
  validates :user_id, presence: true
  validates :draft_id, presence: true

  # validate that the user does not have more selections than the draft permits
  validate :selections_length
  def selections_length
    return unless draft
    if draft.selections.where(user_id: user_id).count > draft.num_selections
      errors.add(:selections, "Maximum number of selections reached")
    end
  end
end