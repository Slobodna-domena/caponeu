class AddEnglishTitleToNovels < ActiveRecord::Migration[7.0]
  def change
    add_column :novels, :english_title, :string
  end
end
