# frozen_string_literal: true

class CreateHouseholds < ActiveRecord::Migration[7.2]
  def change
    create_table :households do |t|
      t.string :name, null: false
      t.string :invite_code, null: false

      t.timestamps null: false
    end

    add_index :households, :invite_code, unique: true
  end
end


