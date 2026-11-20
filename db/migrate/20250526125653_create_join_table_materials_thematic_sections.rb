class CreateJoinTableMaterialsThematicSections < ActiveRecord::Migration[7.0]
  def change
    create_join_table :materials, :thematic_sections do |t|
      t.index [:material_id, :thematic_section_id], name: 'idx_materials_thematic_sections_on_material_and_section'
      t.index [:thematic_section_id, :material_id], name: 'idx_thematic_sections_materials_on_section_and_material'
    end
  end
end
