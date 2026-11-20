class AddPlaceOfDeathToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :place_of_death, :string
  end
end
