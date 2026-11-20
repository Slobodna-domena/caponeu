class Audience < ApplicationRecord

  def self.ransackable_attributes(auth_object = nil)
    ["id", "label"]
  end

end
