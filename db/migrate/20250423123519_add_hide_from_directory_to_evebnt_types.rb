class AddHideFromDirectoryToEvebntTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :event_types, :hide_from_directory, :boolean
  end
end
