class AddAddedByToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :added_by, :string
  end
end
