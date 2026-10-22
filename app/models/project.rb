class Project < ApplicationRecord
  belongs_to :organization
  has_many :tasks, dependent: :destroy
end
