class AddMainEventToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :main_event_id, :integer
  end
end
