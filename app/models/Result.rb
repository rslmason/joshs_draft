class Result < ActiveRecord::Base
  belongs_to :draft
  belongs_to :selection
end