class DeleteIsPublishedFromNews < ActiveRecord::Migration[7.0]
  def change
    remove_column :news, :is_published
  end
end
