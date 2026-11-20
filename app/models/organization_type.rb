class OrganizationType < ApplicationRecord
  has_and_belongs_to_many :organizations

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "label", "updated_at"]
  end

end
