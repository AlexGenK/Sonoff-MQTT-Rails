class Meter < ApplicationRecord
  after_save :generate_topic
  has_many :energies
  belongs_to :consumer

  validates :name, presence: true
  validates :k_trans, numericality: { greater_than: 0 }

  private

  def generate_topic
    unless self.topic
      self.topic = "#{self.id.to_s(16)}-#{SecureRandom.urlsafe_base64}".truncate(32, omission: '')
      save!
    end
  end
end
