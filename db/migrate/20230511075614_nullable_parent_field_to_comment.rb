class NullableParentFieldToComment < ActiveRecord::Migration[7.0]
  def change
    change_column :comments, :parent_id, :bigint, null:true
  end
end
