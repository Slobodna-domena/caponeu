class AddGalleryTitleToNews < ActiveRecord::Migration[7.0]
  def change
    add_column :news, :gallery_title, :string
  end
end
