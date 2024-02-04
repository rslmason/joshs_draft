class CreateSelections < ActiveRecord::Migration[6.1]
  def change
    create_table :selections do |t|
      t.integer :user_id
      t.integer :draft_id
      t.integer :faction
    end
  end
end
