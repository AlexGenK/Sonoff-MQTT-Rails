class Consumer < ApplicationRecord
  has_many :meters

  validates :name, presence: true
end
