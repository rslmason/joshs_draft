class AddNumSelectionsToDrafts < ActiveRecord::Migration[6.0]
  def change
    add_column :drafts, :num_selections, :integer
  end
end
