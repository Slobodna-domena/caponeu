class CreateGeosMaterialsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :geos, :materials
  end
end
