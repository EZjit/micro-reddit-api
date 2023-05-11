class AddIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :username, :string, null: false
    change_column :users, :email, :string, null: false
    change_column :users, :password_digest, :string, null: false
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
