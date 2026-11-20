class AddTimestampsToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :created_at, :datetime, null: false
    add_column :materials, :updated_at, :datetime, null: false
  end
end
