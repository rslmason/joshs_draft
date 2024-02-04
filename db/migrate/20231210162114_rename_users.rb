class RenameUsers < ActiveRecord::Migration[6.1]
  def change
    rename_table :user, :users

  end
end
