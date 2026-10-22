class Activity < ApplicationRecord
  has_many :webhook_events, dependent: :destroy

  before_validation do
    self.provider = provider.to_s.downcase
    self.secret = SecureRandom.hex(32) if secret.blank?
  end

  validates :name, :secret, presence: true
  validates :provider, inclusion: { in: %w[github gitlab] }
end
