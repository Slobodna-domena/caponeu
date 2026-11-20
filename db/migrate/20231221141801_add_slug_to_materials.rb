class AddSlugToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :slug, :string
  end
end
