class AddIsbnAndPublisherIdToNovels < ActiveRecord::Migration[7.0]
  def change
    add_column :novels, :isbn, :string
    add_column :novels, :publisher_id, :integer
  end
end
