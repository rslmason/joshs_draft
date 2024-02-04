class AddTotalPlayersToDraft < ActiveRecord::Migration[6.1]
  def change
    add_column :drafts, :total_players, :integer, limit: 8
  end
end
