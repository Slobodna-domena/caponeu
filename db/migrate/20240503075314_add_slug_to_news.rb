class AddSlugToNews < ActiveRecord::Migration[7.0]
  def change
    add_column :news, :slug, :string
  end
end
