class MigrateNovelLanguagesToJoinTable < ActiveRecord::Migration[7.0]
  def up
    # Only proceed if the language_id column exists
    if column_exists?(:novels, :language_id)
      # Insert existing novel-language relationships into the join table
      execute <<-SQL
        INSERT INTO languages_novels (novel_id, language_id)
        SELECT id, language_id
        FROM novels
        WHERE language_id IS NOT NULL
      SQL
      
      # Remove the language_id column after migration
      remove_column :novels, :language_id
    end
  end

  def down
    # Add the language_id column back
    add_reference :novels, :language, foreign_key: true
    
    # Migrate data back (this will only keep one language per novel)
    execute <<-SQL
      UPDATE novels 
      SET language_id = (
        SELECT language_id 
        FROM languages_novels 
        WHERE languages_novels.novel_id = novels.id 
        LIMIT 1
      )
    SQL
    
    # Remove duplicate associations to maintain one-to-many relationship
    execute "DELETE FROM languages_novels WHERE ctid NOT IN (SELECT min(ctid) FROM languages_novels GROUP BY novel_id, language_id)"
  end
end
