class AddPublishedUntilToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :published_until, :date
  end
end
