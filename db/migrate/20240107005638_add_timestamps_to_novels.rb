class AddTimestampsToNovels < ActiveRecord::Migration[7.0]
  def change
    add_timestamps :novels, default: Time.zone.now
    change_column_default :novels, :created_at, nil
    change_column_default :novels, :updated_at, nil
  end
end
