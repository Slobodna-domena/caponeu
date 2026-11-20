class CreateAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :attachments do |t|
      t.string :file
      t.integer :event_id
      t.float :sort

      t.timestamps
    end
  end
end
