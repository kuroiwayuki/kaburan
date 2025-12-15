# frozen_string_literal: true

class CreateMemos < ActiveRecord::Migration[7.2]
  def change
    create_table :memos do |t|
      t.references :household, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps null: false
    end
  end
end


