class AddTitleToGeos < ActiveRecord::Migration[7.0]
  def change
    add_column :geos, :title, :string
  end
end
