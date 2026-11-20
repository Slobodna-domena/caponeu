class CreateMaterialTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :material_types do |t|
      t.string :label

      t.timestamps
    end
  end
end
