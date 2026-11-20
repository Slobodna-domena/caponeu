class AddCoverSourceToNovelsAndEditions < ActiveRecord::Migration[7.0]
  def change
    add_column :novels, :cover_source, :text
    add_column :editions, :cover_source, :text
  end
end
