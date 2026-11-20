class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable


  def name
    self.full_name ? self.full_name : self.email
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "full_name", "id", "remember_created_at", "updated_at"]
  end

end
