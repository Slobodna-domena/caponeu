class CreateEventTypesEventsJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :events, :event_types
  end
end
