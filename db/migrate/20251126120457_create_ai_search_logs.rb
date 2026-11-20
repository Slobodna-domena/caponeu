class CreateAiSearchLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :ai_search_logs do |t|
      t.integer :user_id
      t.text :query
      t.string :ip_address
      t.timestamps
    end
    add_index :ai_search_logs, :user_id
  end
end
