class Category < ApplicationRecord
  has_and_belongs_to_many :novels
  has_and_belongs_to_many :people


  extend FriendlyId
  friendly_id :label, :use => [:slugged, :finders]
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "label", "updated_at"]
  end

  def type_political_novel?
    category_type == 0
  end

  def type_thematic_collection?
    category_type == 1
  end

end
