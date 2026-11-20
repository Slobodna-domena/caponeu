class AddFurtherReadingToNovels < ActiveRecord::Migration[7.0]
  def change
    add_column :novels, :further_reading, :text
  end
end
