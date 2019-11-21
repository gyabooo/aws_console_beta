class Organization < ApplicationRecord
  has_many :users
  has_many :aws_account
end
