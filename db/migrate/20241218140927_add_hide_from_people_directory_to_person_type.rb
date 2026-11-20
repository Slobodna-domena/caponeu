class AddHideFromPeopleDirectoryToPersonType < ActiveRecord::Migration[7.0]
  def change
    add_column :person_types, :hide_from_people_directory, :boolean
  end
end
