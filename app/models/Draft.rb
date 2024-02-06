class Draft < ActiveRecord::Base
  # Not the ideal way to do this, but it's a start
  after_touch :generate_results
  
  def generate_results
    # return if drawn
    ActiveRecord::Base.transaction do
      if selections.count == (total_players * num_selections) 
        draft_selections = selections
        factions_among_selections = []
        while results.length < draw && draft_selections.length > 0
          drawn = draft_selections.sample
          results << Result.new(draft: self, selection: drawn)
          factions_among_selections << drawn.faction
          draft_selections = draft_selections.reject { |selection|
            selection.faction == drawn.faction 
          }
        end

        if results.length < draw
          house = User.find_or_create_by(name: "<autoselect>", password: "password")
          available_factions = Selection.factions.keys - factions_among_selections
          available_factions.sample(draw - results.length).each do |faction|
            house_selection = Selection.create(draft: self, user: house, faction: faction)
            results << Result.new(draft: self, selection: house_selection)
          end
        end
      end
      self.drawn = true
      save
    end
  end

  has_and_belongs_to_many :users, :join_table => :user_drafts
  has_many :selections, dependent: :destroy
  
  validates :title, presence: true

  has_many :results, dependent: :destroy
  validates :results, length: { maximum: -> (draft) { draft.draw } }

  validates :total_players, presence: true
  validates_numericality_of :total_players, greater_than: 1, less_than_or_equal_to: 8
  validates :users , length: { maximum: :total_players, message: "Maximum number of players reached" }
  validates_numericality_of :num_selections, greater_than: 0, less_than_or_equal_to: 10
  validates_numericality_of :draw, greater_than_or_equal_to: -> (draft) { draft.total_players },  message: "Draw must be greater than or equal to total players"
  validates_numericality_of :draw, less_than_or_equal_to: -> (draft) { Selection.factions.count - 1}, message: "Total drawn must be less than the total number of factions (#{Selection.factions.count}).", if: :exceedsFactions?
  validates_numericality_of :draw, less_than_or_equal_to: -> (draft) { draft.total_players * draft.num_selections }, message: "Total drawn must be less than or equal to total players time selections per player", unless: :exceedsFactions?
  
  def exceedsFactions?
    total_players * num_selections > Selection.factions.count - 1
  end

  def name
    "Draft #{id}"
  end

  def open? 
    users.count < total_players
  end

  def user_selections(user)
    numerator = selections.where(user: user)
    denominator = num_selections
    "#{numerator.count}/#{denominator}"
  end

  scope :open, -> { where("total_players > ?", users.count) }
  scope :closed, -> { where("total_players <= ?", users.count) }
  scope :drawn, -> { where(drawn: true) }
  scope :undrawn, -> { where(drawn: false) }

  alias :players :users

end
