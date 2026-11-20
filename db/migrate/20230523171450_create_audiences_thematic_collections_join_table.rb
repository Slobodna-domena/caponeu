class CreateAudiencesThematicCollectionsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :audiences, :thematic_collections
  end
end
