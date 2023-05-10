class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :body
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :community, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
