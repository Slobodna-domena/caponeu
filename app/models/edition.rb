class Edition < ApplicationRecord
  belongs_to :publisher, class_name: "Organization"
  has_and_belongs_to_many :translators,
    class_name: "Person",
    join_table: "editions_translators",
    association_foreign_key: "person_id"
  belongs_to :novel
  belongs_to :language

  belongs_to :place_of_publication, class_name: "Geo", optional: true

  mount_uploader :cover, CoverUploader

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :finders]

  def self.ransackable_attributes(auth_object = nil)
    ["cover", "from_year", "id", "isbn", "language_id", "novel_id", "place_of_publication", "pof_poi_id", "publisher_id", "title"]
  end

end
