class ThematicSection < ApplicationRecord
  has_and_belongs_to_many :novels
  has_and_belongs_to_many :materials
  has_and_belongs_to_many :people
  has_and_belongs_to_many :events
  has_and_belongs_to_many :keywords
  belongs_to :thematic_collection
end
