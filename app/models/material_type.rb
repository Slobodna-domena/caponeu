class MaterialType < ApplicationRecord
  has_and_belongs_to_many :materials

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "label", "updated_at"]
  end

end
