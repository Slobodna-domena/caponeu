class RemoveCoverFromEditions < ActiveRecord::Migration[7.0]
  def change
    remove_column :editions, :cover
  end
end
