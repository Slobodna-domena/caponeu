class CreateGeos < ActiveRecord::Migration[7.0]
  def change
    create_table :geos do |t|
      t.decimal :latitude
      t.decimal :longitude
      t.string :polygon
    end
  end
end
