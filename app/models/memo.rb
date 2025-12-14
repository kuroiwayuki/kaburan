# frozen_string_literal: true

class Memo < ApplicationRecord
  belongs_to :household
  belongs_to :user
  has_many :items, dependent: :destroy

  accepts_nested_attributes_for :items, allow_destroy: true
end

