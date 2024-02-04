class CreateDrafts < ActiveRecord::Migration[6.1]
  def change
    create_table :drafts do |t|
      t.string :title
      t.string :description
      t.integer :result_id
    end
  end
end
