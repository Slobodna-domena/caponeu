class RemoveAttachmentsFromEvents < ActiveRecord::Migration[7.0]
  def change
    remove_column :events, :attachments
  end
end
