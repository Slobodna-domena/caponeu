class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.string :full_name
      t.date :birth
      t.date :death
      t.string :place_of_birth
    end
  end
end
