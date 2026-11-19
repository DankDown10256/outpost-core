class OrganizationMembership < ApplicationRecord
  self.table_name = "organizations_users"
  self.primary_key = [:organization_id, :user_id]

  belongs_to :organization
  belongs_to :user

  enum :role, {
    owner: "owner",
    admin: "admin",
    member: "member"
  }, validate: true

  scope :managers, -> { where(role: %w[owner admin]) }

  validates :user_id, uniqueness: { scope: :organization_id }
  validate :preserve_owner, on: :update
  before_destroy :protect_membership

  private
    def preserve_owner
      if role_in_database == "owner" && role_changed?
        errors.add(:role, "cannot change the organization owner")
      end
    end

    def protect_membership
      return if destroyed_by_association&.active_record == Organization

      if owner?
        errors.add(:base, "The organization owner cannot be removed.")
        throw :abort
      end

      if organization.teams.joins(:members).where(users: { id: user_id }).exists?
        errors.add(:base, "Remove this user from their teams before removing their membership.")
        throw :abort
      end
    end
end
