class Instance < ApplicationRecord
  belongs_to :aws_account
  has_many :user_instances, dependent: :delete_all
  has_many :users, through: :user_instance
end
