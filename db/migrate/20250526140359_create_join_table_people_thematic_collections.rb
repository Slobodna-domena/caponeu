class CreateJoinTablePeopleThematicCollections < ActiveRecord::Migration[7.0]
  def change
    create_join_table :people, :thematic_collections do |t|
      t.index [:person_id, :thematic_collection_id], name: 'idx_people_thematic_colls_on_person_and_collection'
      t.index [:thematic_collection_id, :person_id], name: 'idx_thematic_colls_people_on_collection_and_person'
    end
  end
end
