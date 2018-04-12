class Meter < ApplicationRecord
  before_create :generate_topic
  has_many :energies

  private

  def generate_topic
    self.topic = "#{self.consumer_id.to_s(16)}-#{SecureRandom.urlsafe_base64}".truncate(32, omission: '')
  end
end
