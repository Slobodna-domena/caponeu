class CreateKeywordsThematicCollectionsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :keywords, :thematic_collections
  end
end
