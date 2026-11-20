class AddSortToOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :organizations, :sort, :float
  end
end
