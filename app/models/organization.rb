class Organization < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :teams, dependent: :restrict_with_error
  has_many :projects, dependent: :restrict_with_error
  has_many :invitations, dependent: :destroy

  validates :name, presence: true
  validate :keep_team_members

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
