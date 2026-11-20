class AddTitleToPeople < ActiveRecord::Migration[7.0]
  def change
    add_column :people, :title, :string
  end
end
