class Organization < ApplicationRecord
  has_many :teams, dependent: :restrict_with_error
  has_many :projects, dependent: :restrict_with_error
  has_many :invitations, dependent: :destroy
  has_many :organization_memberships, dependent: :destroy
  has_many :users, through: :organization_memberships

  validates :name, presence: true
  validate :keep_team_members

  def managed_by?(user)
    organization_memberships.managers.exists?(user_id: user.id)
  end

  def owned_by?(user)
    organization_memberships.owner.exists?(user_id: user.id)
  end

  private
    def keep_team_members
      remaining_user_ids = users.map(&:id)
      if teams.includes(:members).any? { |team|
        team.members.any? { |member| !remaining_user_ids.include?(member.id) }
      }
        errors.add(:users, "cannot remove users who still belong to a team")
      end
    end
end
