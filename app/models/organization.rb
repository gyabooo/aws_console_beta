class Organization < ApplicationRecord
  has_many :organization_users, dependent: :delete_all
  has_many :users, through: :organization_users
  has_many :aws_accounts, dependent: :delete_all
  belongs_to :owner, class_name: "User"
end
