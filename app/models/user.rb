class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :organization_users
  has_many :organizations, through: :organization_users
  has_many :aws_accounts, through: :organizations
  has_many :user_instance
  has_many :instances, through: :user_instance, dependent: :destroy
  has_many :subordinates, class_name: "User", foreign_key: "manager_id"
  belongs_to :manager, class_name: "User", optional: true

  enum role: ['general', 'admin', 'system_admin']

  validates :name, presence: true
end
