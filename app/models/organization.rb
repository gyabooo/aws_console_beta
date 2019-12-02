class Organization < ApplicationRecord
  has_many :organization_users
  has_many :users, through: :organization_users
  has_many :aws_accounts
  belongs_to :owner, class_name: "User"
end
