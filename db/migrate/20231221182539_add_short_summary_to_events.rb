class AddShortSummaryToEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :short_summary, :text
  end
end
