class CreateUserDrafts < ActiveRecord::Migration[6.1]
  def change
    create_table :user_drafts do |t|
      t.integer :user_id
      t.integer :draft_id
    end
  end
end
