class CreatePeoplePersonTypesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :people, :person_types
  end
end
