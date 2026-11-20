class CreateGalleries < ActiveRecord::Migration[7.0]
  def change
    create_table :galleries do |t|
      t.string :title
      t.string :image
      t.string :video
      t.string :caption
      t.integer :news_id

      t.timestamps
    end
  end
end
