# frozen_string_literal: true

class AddQuantityToItems < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :quantity, :integer, default: 1, null: false
  end
end

