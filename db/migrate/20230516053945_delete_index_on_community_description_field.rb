class DeleteIndexOnCommunityDescriptionField < ActiveRecord::Migration[7.0]
  def change
    remove_index :communities, name: "index_communities_on_description"
  end
end
