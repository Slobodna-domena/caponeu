class CreateJoinTableNovelsThematicSections < ActiveRecord::Migration[7.0]
  def change
    create_join_table :novels, :thematic_sections do |t|
      t.index [:novel_id, :thematic_section_id], name: 'idx_novels_thematic_sections_on_novel_and_section'
      t.index [:thematic_section_id, :novel_id], name: 'idx_thematic_sections_novels_on_section_and_novel'
    end
  end
end
