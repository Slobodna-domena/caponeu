class Gallery < ApplicationRecord

  before_save :process_video_id

  mount_uploader :image, PersonPhotoUploader

  scope :not_empty, -> { where("image != '' OR video != ''")}

  def process_video_id
    return unless video.present? 
    if video.include?('youtube.com/watch?v=')
      self.video = video.split('v=').last.split('&').first
    elsif video.include?('youtu.be/')
      self.video = video.split('youtu.be/').last.split('?').first
    end
  end

end

