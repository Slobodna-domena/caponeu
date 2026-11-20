class AddMetadataToVersions < ActiveRecord::Migration[7.0]
  def change
    add_column :versions, :object_changes, :text, limit: 1_073_741_823
    add_column :versions, :metadata, :jsonb
  end
end
