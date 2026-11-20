class AddPhotoAndBioToPerson < ActiveRecord::Migration[7.0]
  def change
    change_table :people do |t|
      t.column :photo, :string
      t.column :bio, :text
    end
  end
end
