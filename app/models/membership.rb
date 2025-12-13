# frozen_string_literal: true

class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :household

  validates :user_id, uniqueness: { scope: :household_id }
end

