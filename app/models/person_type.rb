class PersonType < ApplicationRecord
  has_and_belongs_to_many :people

  def self.ransackable_attributes(auth_object = nil)
    ["id", "label"]
  end

end
