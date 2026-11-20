class AddOrganizationIdToThematicCollections < ActiveRecord::Migration[7.0]
  def change
    add_column :thematic_collections, :organization_id, :integer
  end
end
