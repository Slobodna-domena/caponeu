class CreateJoinTableNovelsThematicCollections < ActiveRecord::Migration[7.0]
  def change
    create_join_table :novels, :thematic_collections
  end
end
