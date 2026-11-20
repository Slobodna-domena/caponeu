class AddSlugToThematicCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :thematic_collections, :slug, :string
  end
end
