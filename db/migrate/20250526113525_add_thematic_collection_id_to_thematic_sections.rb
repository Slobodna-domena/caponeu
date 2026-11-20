class AddThematicCollectionIdToThematicSections < ActiveRecord::Migration[7.0]
  def change
    add_column :thematic_sections, :thematic_collection_id, :integer
  end
end
