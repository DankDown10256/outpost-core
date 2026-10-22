class WebhookEvent < ApplicationRecord
  belongs_to :activity

  validates :delivery_id, :event, :summary, presence: true
end
