class AddPortraitTitleToNovels < ActiveRecord::Migration[7.0]
  def change
    add_column :novels, :portrait_title, :string
  end
end
