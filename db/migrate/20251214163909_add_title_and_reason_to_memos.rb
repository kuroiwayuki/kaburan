# frozen_string_literal: true

class AddTitleAndReasonToMemos < ActiveRecord::Migration[7.2]
  def change
    add_column :memos, :title, :string
    add_column :memos, :reason, :text
  end
end


