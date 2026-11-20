class ThematicCollection < ApplicationRecord
  belongs_to :organization, optional: true
  has_many :thematic_sections, -> { order(:sort) }
  has_and_belongs_to_many :keywords
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :audiences
  has_and_belongs_to_many :people

  accepts_nested_attributes_for :thematic_sections, allow_destroy: true

  mount_uploader :cover, CoverUploader

  scope :active, -> { where(active: true) }

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :finders]

  def self.ransackable_attributes(auth_object = nil)
    ["cover", "id", "summary", "title"]
  end
end
