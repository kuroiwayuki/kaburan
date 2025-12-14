# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :memo

  validates :name, presence: true
  validates :quantity, presence: true, numericality: { greater_than: 0 }
end

