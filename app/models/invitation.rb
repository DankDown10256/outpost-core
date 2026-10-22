class Invitation < ApplicationRecord
  belongs_to :organization
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  enum :status, {
    pending: "pending",
    accepted: "accepted",
    declined: "declined"
  }, validate: true

  validates :recipient_id, uniqueness: { scope: :organization_id }

  def respond!(response)
    with_lock do
      return unless pending?

      if response == "accepted"
        organization.with_lock do
          unless organization.users.exists?(recipient_id)
            organization.users << recipient
          end
        end
      end

      update!(status: response)
    end
  end
end
