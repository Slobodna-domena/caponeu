class AddTimestampsToKeywords < ActiveRecord::Migration[7.0]
  def change
    add_timestamps :keywords, default: Time.zone.now
    change_column_default :keywords, :created_at, nil
    change_column_default :keywords, :updated_at, nil
  end
end
