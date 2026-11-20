class CreateMaterialsOrganizationsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :materials, :organizations
  end
end
