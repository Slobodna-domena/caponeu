class Attachment < ApplicationRecord
  mount_uploader :file, AttachmentUploader

  def filename
    title.present? ? title : file.file.filename
  end

end
