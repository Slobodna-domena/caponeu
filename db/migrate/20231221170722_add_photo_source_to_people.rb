class AddPhotoSourceToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :photo_source, :text
  end
end
