class AddDrawToDrafts < ActiveRecord::Migration[6.0]
  def change
    add_column :drafts, :draw, :integer
  end
end
