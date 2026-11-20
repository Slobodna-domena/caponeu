class AddEventIdToGalleries < ActiveRecord::Migration[7.0]
  def change
    add_column :galleries, :event_id, :integer
  end
end
