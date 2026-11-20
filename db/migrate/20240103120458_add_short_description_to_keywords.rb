class AddShortDescriptionToKeywords < ActiveRecord::Migration[7.0]
  def change
    add_column :keywords, :short_description, :string
  end
end
