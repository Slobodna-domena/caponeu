class CreateJoinTableGeosOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_join_table :geos, :organizations do |t|
      # t.index [:geo_id, :organization_id]
      # t.index [:organization_id, :geo_id]
    end
  end
end
