class CreateAdaptations < ActiveRecord::Migration[7.0]
  def change
    create_table :adaptations do |t|
      t.string :title
      t.integer :year
      t.references :adaptation_type, null: false, foreign_key: true
      t.text :description
      t.references :novel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
