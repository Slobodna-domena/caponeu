class Language < ApplicationRecord

  has_and_belongs_to_many :novels

  extend FriendlyId
  friendly_id :label, :use => [:slugged, :finders]
  def self.ransackable_attributes(auth_object = nil)
    ["id", "label"]
  end

end
