class AddHideFromTimelineToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :hide_from_timeline, :boolean
  end
end
