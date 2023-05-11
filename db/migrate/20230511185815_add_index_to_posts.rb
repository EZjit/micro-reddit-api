class AddIndexToPosts < ActiveRecord::Migration[7.0]
  def change
    change_column :posts, :title, :string, null: false
    change_column :posts, :body, :string, null: false
    add_index :posts, :title
  end
end
