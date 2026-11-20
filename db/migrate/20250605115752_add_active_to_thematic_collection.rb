class AddActiveToThematicCollection < ActiveRecord::Migration[7.0]
  def change
    add_column :thematic_collections, :active, :boolean
  end
end
