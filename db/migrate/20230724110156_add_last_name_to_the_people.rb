class AddLastNameToThePeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :last_name, :string
    rename_column :people, :full_name, :first_name
  end
end
