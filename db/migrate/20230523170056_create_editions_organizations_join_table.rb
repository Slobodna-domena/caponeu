class CreateEditionsOrganizationsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :editions, :organizations
  end
end
