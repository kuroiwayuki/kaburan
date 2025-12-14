class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_many :memberships, dependent: :destroy
  has_many :households, through: :memberships
  has_many :created_households, class_name: "Household", foreign_key: "creator_id", dependent: :destroy
  has_many :memos, dependent: :destroy
end
