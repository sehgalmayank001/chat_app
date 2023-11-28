class Conversation < ApplicationRecord
  belongs_to :profile
  has_many :messages
end
