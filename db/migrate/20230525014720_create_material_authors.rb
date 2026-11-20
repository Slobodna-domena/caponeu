class CreateMaterialAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :material_authors do |t|
      t.belongs_to :material
      t.belongs_to :person

    end
  end
end
