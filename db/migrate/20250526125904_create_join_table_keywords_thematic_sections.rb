class CreateJoinTableKeywordsThematicSections < ActiveRecord::Migration[7.0]
  def change
    create_join_table :keywords, :thematic_sections do |t|
      t.index [:keyword_id, :thematic_section_id], name: 'idx_keywords_thematic_sections_on_keyword_and_section'
      t.index [:thematic_section_id, :keyword_id], name: 'idx_thematic_sections_keywords_on_section_and_keyword'
    end
  end
end
