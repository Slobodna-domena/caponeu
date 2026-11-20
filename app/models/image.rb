class Image < ApplicationRecord
  mount_uploader :image, PersonPhotoUploader
end
