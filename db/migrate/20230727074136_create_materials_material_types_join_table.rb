class CreateMaterialsMaterialTypesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :materials, :material_types
  end
end
