class CreateJoinTablePeopleThematicSections < ActiveRecord::Migration[7.0]
  def change
    create_join_table :people, :thematic_sections do |t|
      t.index [:person_id, :thematic_section_id], name: 'idx_people_thematic_sections_on_person_and_section'
      t.index [:thematic_section_id, :person_id], name: 'idx_thematic_sections_people_on_section_and_person'
    end
  end
end
