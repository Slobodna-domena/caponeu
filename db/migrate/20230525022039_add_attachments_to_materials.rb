class AddAttachmentsToMaterials < ActiveRecord::Migration[7.0]
  def change
    add_column :materials, :attachments, :json
  end
end
