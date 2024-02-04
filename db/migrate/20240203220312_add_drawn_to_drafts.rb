class AddDrawnToDrafts < ActiveRecord::Migration[6.0]
  def change
    add_column :drafts, :drawn, :boolean, default: false
  end
end
