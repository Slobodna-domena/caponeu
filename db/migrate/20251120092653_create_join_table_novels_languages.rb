class CreateJoinTableNovelsLanguages < ActiveRecord::Migration[7.0]
  def change
    create_join_table :novels, :languages do |t|
      t.index [:novel_id, :language_id]
      t.index [:language_id, :novel_id]
    end
  end
end
