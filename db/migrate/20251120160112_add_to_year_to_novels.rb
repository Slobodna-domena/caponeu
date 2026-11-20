class AddToYearToNovels < ActiveRecord::Migration[7.0]
  def change
    add_column :novels, :to_year, :integer
  end
end
