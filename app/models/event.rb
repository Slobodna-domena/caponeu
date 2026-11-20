class Event < ApplicationRecord
  has_and_belongs_to_many :novels
  has_and_belongs_to_many :geos
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :keywords
  has_and_belongs_to_many :event_types
  has_and_belongs_to_many :people, -> { order("last_name, first_name") }
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :thematic_sections
  has_many :attachments, -> { order(:id) }
  has_many :galleries, -> { order(:id) }
  has_many :subevents, class_name: "Event",
                       foreign_key: "main_event_id"

  belongs_to :main_event, class_name: "Event", optional: true

  accepts_nested_attributes_for :attachments, allow_destroy: true
  accepts_nested_attributes_for :galleries, allow_destroy: true

  scope :not_hidden, -> { where(hide_from_timeline: [false, nil]) }
  scope :show_in_directory, -> { joins(:event_types).where(event_types: { hide_from_directory: [nil, false] }).distinct }
  

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  def timeline_title(year)
    if started and ended and started.year != ended.year
      word = started.year == year ? "started" : "ended"
      "#{title} #{word}"
    else
      title
    end
  end

  def collections
    thematic_sections.map(&:thematic_collection).uniq
  end
end
