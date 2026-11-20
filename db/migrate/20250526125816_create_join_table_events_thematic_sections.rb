class CreateJoinTableEventsThematicSections < ActiveRecord::Migration[7.0]
  def change
    create_join_table :events, :thematic_sections do |t|
      t.index [:event_id, :thematic_section_id], name: 'idx_events_thematic_sections_on_event_and_section'
      t.index [:thematic_section_id, :event_id], name: 'idx_thematic_sections_events_on_section_and_event'
    end
  end
end
