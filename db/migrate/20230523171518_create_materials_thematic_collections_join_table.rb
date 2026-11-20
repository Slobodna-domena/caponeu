class CreateMaterialsThematicCollectionsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :materials, :thematic_collections
  end
end
