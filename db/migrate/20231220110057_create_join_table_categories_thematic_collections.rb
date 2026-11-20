class CreateJoinTableCategoriesThematicCollections < ActiveRecord::Migration[7.0]
  def change
    create_join_table :categories, :thematic_collections
  end
end
