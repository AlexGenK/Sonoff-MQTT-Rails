class Meter < ApplicationRecord
  before_create :generate_topic
  has_many :energies

  private

  def generate_topic
    self.topic = "#{self.consumer_id}-#{SecureRandom.uuid}"
  end
end
