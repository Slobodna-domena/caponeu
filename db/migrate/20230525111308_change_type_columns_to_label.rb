class ChangeTypeColumnsToLabel < ActiveRecord::Migration[7.0]
  def change
    rename_column :event_types, :type, :label
    rename_column :organization_types, :type, :label
    rename_column :person_types, :type, :label
  end
end
