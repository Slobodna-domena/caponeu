class AddHideFromDirectoryToOrganizationTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :organization_types, :hide_from_directory, :boolean
  end
end
