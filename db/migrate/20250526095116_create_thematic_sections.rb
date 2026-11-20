class CreateThematicSections < ActiveRecord::Migration[7.0]
  def change
    create_table :thematic_sections do |t|
      t.string :title
      t.text :summary
      t.string :related_model
      t.float :sort

      t.timestamps
    end
  end
end
