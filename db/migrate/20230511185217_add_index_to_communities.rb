class AddIndexToCommunities < ActiveRecord::Migration[7.0]
  def change
    change_column :communities, :name, :string, null: false
    change_column :communities, :description, :string, null: false
    add_index :communities, :name, unique: true
    add_index :communities, :description, unique: true
  end
end
