class Keyword < ApplicationRecord
  has_and_belongs_to_many :novels
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :thematic_sections
  has_and_belongs_to_many :events

  has_many :children, class_name: "Keyword",
                      foreign_key: "parent_id"

  belongs_to :parent, class_name: "Keyword", optional: true

  extend FriendlyId
  friendly_id :label, :use => [:slugged, :finders]
  def self.ransackable_attributes(auth_object = nil)
    ["id", "label", "parent_id"]
  end

  def collections
    thematic_sections.map(&:thematic_collection).uniq
  end
end
