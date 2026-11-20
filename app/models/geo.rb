class Geo < ApplicationRecord
  has_many :editions, foreign_key: :place_of_publication_id
  has_many :novels_with_origin_here, class_name: "Novel", foreign_key: :place_of_origin_id, dependent: :nullify
  has_and_belongs_to_many :novels
  has_and_belongs_to_many :events
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :organizations

  def self.ransackable_attributes(auth_object = nil)
    ["id", "latitude", "longitude", "polygon", "title"]
  end

  scope :without_coordinates, -> {
    where("(latitude IS NULL OR longitude IS NULL) AND (polygon IS NULL OR polygon = '')")
  }

  def mappable?
    latitude.present? && longitude.present?
  end

  def related_events
    EventType.find_by_label("historical event").events
  end

  def related_novels
    novels
  end
end
