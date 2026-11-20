class CreateOrganizationsOrganizationTypesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :organizations, :organization_types
  end
end
