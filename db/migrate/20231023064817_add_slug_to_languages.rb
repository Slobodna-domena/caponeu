class AddSlugToLanguages < ActiveRecord::Migration[7.0]
  def change
    add_column :languages, :slug, :string
  end
end
