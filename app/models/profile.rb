class Profile < ApplicationRecord
  enum category: { realistic: 0, anime: 1 }
  enum gender: { male: 0, female: 1 }

  has_many :conversations

  def self.ransackable_attributes(auth_object = nil)
    ["category", "gender"]
  end
end

