# frozen_string_literal: true

class AddCreatorIdToHouseholds < ActiveRecord::Migration[7.2]
  def change
    add_reference :households, :creator, null: true, foreign_key: { to_table: :users }
  end
end


