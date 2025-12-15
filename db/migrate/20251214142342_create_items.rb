# frozen_string_literal: true

class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.references :memo, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :purchased, default: false, null: false

      t.timestamps null: false
    end
  end
end


