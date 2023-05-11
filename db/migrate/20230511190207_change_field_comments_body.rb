class ChangeFieldCommentsBody < ActiveRecord::Migration[7.0]
  def change
    change_column :comments, :body, :string, null: false
  end
end
