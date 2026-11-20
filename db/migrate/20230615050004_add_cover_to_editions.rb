class AddCoverToEditions < ActiveRecord::Migration[7.0]
  def change
    add_column :editions, :cover, :string
  end
end
