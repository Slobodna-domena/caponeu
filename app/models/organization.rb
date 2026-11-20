class Organization < ApplicationRecord
  has_many :thematic_collections
  has_and_belongs_to_many :organization_types
  has_and_belongs_to_many :people, -> { order("last_name, first_name") }
  has_and_belongs_to_many :novels
  has_and_belongs_to_many :events
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :geos
  has_many :editions, foreign_key: "publisher_id"

  mount_uploader :logo, LogoUploader

  extend FriendlyId
  friendly_id :label, :use => [:slugged, :finders]

  def full_name
    label
  end

  def title
    label
  end

  def novels_and_editions
    novels + editions.map(&:novel)
  end

  def people_and_authors
    people
  end

  def self.publishers
    OrganizationType.find(1).organizations
  end

  def self.parties
    OrganizationType.find(2).organizations
  end

  def self.institution
    OrganizationType.find(3).organizations
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "label"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["editions", "events", "novels", "organization_types", "people"]
  end
end
