class CreateOrganizationsPeopleJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :organizations, :people
  end
end
