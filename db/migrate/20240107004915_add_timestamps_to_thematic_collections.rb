class AddTimestampsToThematicCollections < ActiveRecord::Migration[7.0]
  def change
    add_timestamps :thematic_collections, default: Time.zone.now
    change_column_default :thematic_collections, :created_at, nil
    change_column_default :thematic_collections, :updated_at, nil
  end
end
