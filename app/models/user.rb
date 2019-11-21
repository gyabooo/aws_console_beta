class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # has_many :children, class_name: "User", foreign_key: "parent_id"
  # belongs_to :parent, class_name: "User", optional: true
  belongs_to :organization
end
