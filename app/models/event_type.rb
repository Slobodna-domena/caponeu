class EventType < ApplicationRecord
  has_and_belongs_to_many :events
  def self.ransackable_attributes(auth_object = nil)
    ["id", "label"]
  end
end
