class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :title
      t.text :summary
      t.text :content
      t.text :external_document
      t.boolean :public
      t.boolean :produced_by_caponeu
      t.string :material_type
      t.string :copyright_notice

    end
  end
end
