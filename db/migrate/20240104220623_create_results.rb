class CreateResults < ActiveRecord::Migration[6.1]
  def change
    create_table :results do |t|
      t.integer :draft_id
      t.integer :selection_id
    end
  end
end
