# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :memo

  validates :name, presence: true
end

