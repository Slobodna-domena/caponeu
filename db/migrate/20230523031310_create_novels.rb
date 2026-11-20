class CreateNovels < ActiveRecord::Migration[7.0]
  def change
    create_table :novels do |t|
      t.string :title
      t.integer :from_year
      t.text :portrait_summary
      t.text :summary
      t.string :place_of_origin
      t.date :written_at
      t.belongs_to :language
      t.belongs_to :pof_poi, class_name: "Person"
    end
  end
end
