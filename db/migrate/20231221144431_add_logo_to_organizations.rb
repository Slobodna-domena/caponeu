class AddLogoToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :logo, :string
  end
end
