class Material < ApplicationRecord
  mount_uploaders :attachments, AttachmentUploader

  has_and_belongs_to_many :keywords
  has_and_belongs_to_many :events
  has_and_belongs_to_many :people
  has_and_belongs_to_many :organizations, -> { order("label") }
  has_and_belongs_to_many :geos
  has_and_belongs_to_many :thematic_sections
  has_and_belongs_to_many :novels
  has_and_belongs_to_many :material_types
  has_and_belongs_to_many :authors,
    join_table: "material_authors",
    class_name: "Person",
    inverse_of: :novel_authors

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :finders]

  def self.ransackable_attributes(auth_object = nil)
    ["attachments", "content", "copyright_notice", "created_at", "external_document", "id", "material_type", "produced_by_caponeu", "public", "summary", "title", "updated_at"]
  end

  def full_name
    title
  end

  def collections
    thematic_sections.map(&:thematic_collection).uniq
  end
end
