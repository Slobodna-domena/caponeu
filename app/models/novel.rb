class Novel < ApplicationRecord

  has_many :editions
  accepts_nested_attributes_for :editions, :allow_destroy => true

  has_many :adaptations
  accepts_nested_attributes_for :adaptations, :allow_destroy => true

  has_and_belongs_to_many :events
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :people
  has_and_belongs_to_many :geos
  has_and_belongs_to_many :keywords
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :thematic_sections

  has_and_belongs_to_many :authors,
                          join_table: "novel_authors",
                          class_name: "Person",
                          inverse_of: :novel_authors

  has_and_belongs_to_many :portrait_authors,
                          join_table: "novel_portrait_authors",
                          class_name: "Person",
                          inverse_of: :novel_portrait_authors

  mount_uploader :cover, CoverUploader

  belongs_to :place_of_origin, class_name: "Geo", optional: true

  extend FriendlyId
  friendly_id :title, :use => [:slugged, :finders]

  before_update :set_redirect

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  def full_name
    title
  end

  def publishers
    editions.map(&:publisher).uniq
  end

  def people_and_authors
    authors + people
  end

  def self.ransackable_attributes(auth_object = nil)
    ["censorship_status", "cover", "english_title", "from_year", "id", "place_of_origin", "pof_poi_id", "portrait_summary", "portrait_title", "summary", "title", "written_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["authors", "categories", "editions", "events", "geos", "keywords", "languages", "materials", "organizations", "people", "place_of_origin", "portrait_authors"]
  end

  def related_events
    events.joins(:event_types).where(event_types: { label: "historical event" }).distinct
  end

  def related_novels
    novels = []
    geos.each do |geo|
      novels << geo.novels
    end
    novels << place_of_origin.novels if place_of_origin
    novels.flatten.uniq
  end

  def collections
    thematic_sections.map(&:thematic_collection).uniq
  end

  def map_locations
    [*geos, place_of_origin].compact.uniq.select(&:mappable?)
  end

  private

  def set_redirect
    if will_save_change_to_attribute?(:title)
      path = "/cdp/novels/"
      Redirect.create(old_url: path + slug_was, new_url: path + slug)
    end
  end
end
