class AddSlugToNovel < ActiveRecord::Migration[7.0]
  def change
    add_column :novels, :slug, :string
  end
end
