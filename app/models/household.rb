# frozen_string_literal: true

class Household < ApplicationRecord
  validates :name, presence: true
  validates :invite_code, presence: true, uniqueness: true

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :memos, dependent: :destroy

  before_validation :generate_invite_code, on: :create

  private

  def generate_invite_code
    return if invite_code.present?

    loop do
      self.invite_code = SecureRandom.alphanumeric(8).upcase
      break unless Household.exists?(invite_code: invite_code)
    end
  end
end

