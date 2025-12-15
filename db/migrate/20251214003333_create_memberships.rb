# frozen_string_literal: true

class CreateMemberships < ActiveRecord::Migration[7.2]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :household, null: false, foreign_key: true

      t.timestamps null: false
    end

    add_index :memberships, [:user_id, :household_id], unique: true
  end
end


