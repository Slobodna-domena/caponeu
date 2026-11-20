class RemovePortraitTitleFromNovels < ActiveRecord::Migration[7.0]
  def change
    remove_column :novels, "portrait_title"
  end
end
