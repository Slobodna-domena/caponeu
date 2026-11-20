class ChangeThematicCollections < ActiveRecord::Migration[7.0]
  def change
    remove_column :thematic_collections, :cover
    add_column :thematic_collections, :cover, :string
  end
end
