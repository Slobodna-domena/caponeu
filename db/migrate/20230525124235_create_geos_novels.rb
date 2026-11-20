class CreateGeosNovels < ActiveRecord::Migration[7.0]
  def change
    create_table :geos_novels do |t|
      t.belongs_to :geo
      t.belongs_to :novel
    end
  end
end
