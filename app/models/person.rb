class Person < ApplicationRecord
  has_and_belongs_to_many :novels
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :events
  has_and_belongs_to_many :person_types, -> { order("label") }
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :thematic_sections

  has_and_belongs_to_many :translated_editions,
    join_table: "editions_translators",
    class_name: "Edition",
    association_foreign_key: "edition_id"

  has_and_belongs_to_many :novel_authors,
    join_table: "novel_authors",
    class_name: "Novel",
    inverse_of: :novel_authors

  has_and_belongs_to_many :portrait_authors,
    join_table: "novel_portrait_authors",
    class_name: "Novel",
    inverse_of: :novel_portrait_authors

  has_and_belongs_to_many :authors,
    join_table: "material_authors",
    class_name: "Material",
    inverse_of: :material_authors

  before_update :set_redirect

  mount_uploader :photo, PersonPhotoUploader

  scope :show_in_directory, -> { joins(:person_types).where(person_types: { hide_from_people_directory: [nil, false] }).distinct }

  extend FriendlyId
  friendly_id :slug_candidates, :use => [:slugged, :finders]

  def should_generate_new_friendly_id?
    (first_name_changed? or last_name_changed?) || super
  end

  def slug_candidates
    [
      [:first_name, :last_name],
    ]
  end

  def novels_and_portraits
    novel_authors + portrait_authors + novels + translated_editions.includes(:novel).map(&:novel)
  end

  def get_photo
    if photo.url.nil?
      "default_person.png"
    else
      photo.url
    end
  end

  def get_photo_compact
    if photo.url.nil?
      "default_person.png"
    else
      photo.compact.url
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.all_authors
    PersonType.find(1).people
  end

  def self.all_portrait_authors
    PersonType.find(2).people + PersonType.find(9).people
  end

  def self.other
    PersonType.where("id > 2").map { |type| type.people }.flatten
  end

  def self.not_caponeu_team
    PersonType.where("id != 2").map { |type| type.people }.flatten
  end

  def self.ransackable_attributes(auth_object = nil)
    ["birth", "death", "first_name", "id", "last_name", "place_of_birth"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["authors", "events", "materials", "novels", "organizations", "person_types"]
  end

  def birth_timestamp
    self.birth ? self.birth.to_time.to_i : -10000000000
  end

  def death_timestamp
    self.death ? self.death.to_time.to_i : 0
  end

  def collections
    thematic_sections.map(&:thematic_collection).uniq
  end

  private

  def set_redirect
    if will_save_change_to_attribute?(:first_name) or will_save_change_to_attribute?(:last_name)
      path = "/cdp/people/"
      Redirect.create(old_url: path + slug_was, new_url: path + slug)
    end
  end
end
