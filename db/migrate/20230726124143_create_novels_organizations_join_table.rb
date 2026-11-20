class CreateNovelsOrganizationsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :novels, :organizations
  end
end
