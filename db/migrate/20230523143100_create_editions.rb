class CreateEditions < ActiveRecord::Migration[7.0]
  def change
    create_table :editions do |t|
      t.belongs_to :novel
      t.string :title
      t.belongs_to :language
      t.belongs_to :publisher, class_name: "Organization"
      t.integer :from_year
      t.belongs_to :translator, class_name: "Person"
      t.string :isbn
      t.string :place_of_publication
      t.belongs_to :pof_poi, class_name: "Person"
      t.binary :cover

    end
  end
end
