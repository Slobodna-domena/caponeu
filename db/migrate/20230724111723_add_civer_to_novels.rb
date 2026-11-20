class AddCiverToNovels < ActiveRecord::Migration[7.0]
  def change
    add_column :novels, :cover, :string
  end
end
