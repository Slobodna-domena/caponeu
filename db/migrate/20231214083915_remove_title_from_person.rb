class RemoveTitleFromPerson < ActiveRecord::Migration[7.0]
  def change
    remove_column :people, :title
  end
end
