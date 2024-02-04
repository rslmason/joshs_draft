class Draft < ActiveRecord::Base
  # Not the ideal way to do this, but it's a start
  after_touch :generate_results
  
  
  # after_save :say_hello
  # after_save :generate_results, if: -> { selections.count == (total_players * num_selections) }
  # after_save :say_i_am_saved

  # def say_i_am_saved
  #   Rails.logger.info "-----------------"
  #   Rails.logger.info "I am saved"
  #   Rails.logger.info "-----------------"
  # end

  # def say_hello
  #   Rails.logger.info "Hello from the after_touch callback"
  # end

  def generate_results
    return if drawn
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
          house = User.find_or_create_by(name: "House", password: "password")
          available_factions = Selection.factions.keys - factions_among_selections
          available_factions.sample(draw - results.length).each do |faction|
            house_selection = Selection.create(draft: self, user: house, faction: faction)
            results << Result.new(draft: self, selection: house_selection)
          end
        end
      end
      drawn = true
      save
    end
  end




  has_and_belongs_to_many :users, :join_table => :user_drafts
  has_many :selections, dependent: :destroy
  # can't use scope this way?
  # validates :selections, length: { maximum: -> (draft) { draft.num_selections }}
  # validates :selections, length: { maximum: -> { num_selections }, scope: :user_id}
  validate :selections_length
  # working on this validation as a method
  def selections_length
    if selections.count > num_selections
      errors.add(:selections, "Maximum number of selections reached")
    end
  end

  has_many :results, dependent: :destroy
  validates :results, length: { maximum: -> (draft) { draft.draw } }


  validates :total_players, presence: true,  length: { mininmum: 2, maximum: 8 }
  validates :users , length: { maximum: :total_players, message: "Maximum number of players reached" }

  validates_numericality_of :num_selections, greater_than: 0, less_than_or_equal_to: 10
  validates_numericality_of :draw, greater_than_or_equal_to: -> (draft) { draft.total_players }, less_than_or_equal_to: -> (draft) {draft.total_players * draft.num_selections} 

  def name
    "Draft #{id}"
  end

  def self.class_method
    "class method"
  end

  def open? 
    users.count < total_players
  end

  alias :players :users

end
