class CreateEditionsTranslators < ActiveRecord::Migration[7.0]
  def up
    create_table :editions_translators, id: false do |t|
      t.bigint :edition_id, null: false
      t.bigint :person_id, null: false
      t.index [:edition_id, :person_id], unique: true
      t.index [:person_id, :edition_id]
    end

    # Prenesi postojeće veze 1:1 u novu tablicu
    execute <<-SQL
      INSERT INTO editions_translators (edition_id, person_id)
      SELECT id, translator_id
      FROM editions
      WHERE translator_id IS NOT NULL
    SQL

    remove_index :editions, :translator_id if index_exists?(:editions, :translator_id)
    remove_column :editions, :translator_id
  end

  def down
    add_column :editions, :translator_id, :bigint
    add_index :editions, :translator_id

    # Vraća samo jednog prevoditelja (s najnižim person_id) po izdanju
    execute <<-SQL
      UPDATE editions
      SET translator_id = (
        SELECT MIN(person_id) FROM editions_translators
        WHERE editions_translators.edition_id = editions.id
      )
    SQL

    drop_table :editions_translators
  end
end
