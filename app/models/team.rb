class Team < ApplicationRecord
  belongs_to :organization
  has_and_belongs_to_many :members,
    class_name: "User", join_table: "teams_users",
    foreign_key: "team_id", association_foreign_key: "user_id"

  validate :members_belong_to_organization

  private
    def members_belong_to_organization
      return unless organization

      organization_user_ids = organization.user_ids
      if members.any? { |member| !organization_user_ids.include?(member.id) }
        errors.add(:members, "must belong to the selected organization")
      end
    end
end
