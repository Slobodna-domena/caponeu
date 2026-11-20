class AddSlugsToEditions < ActiveRecord::Migration[7.0]
  def change
    add_column :editions, :slug, :string
  end
end
