class Meter < ApplicationRecord
  after_save :generate_topic
  has_many :energies
  belongs_to :consumer

  private

  def generate_topic
    unless self.topic
      self.topic = "#{self.id.to_s(16)}-#{SecureRandom.urlsafe_base64}".truncate(32, omission: '')
      self.save!
    end
  end
end
