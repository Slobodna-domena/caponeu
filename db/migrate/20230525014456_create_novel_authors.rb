class CreateNovelAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :novel_authors do |t|
      t.belongs_to :novel
      t.belongs_to :person
    end
  end
end
