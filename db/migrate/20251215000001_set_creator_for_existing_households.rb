# frozen_string_literal: true

class SetCreatorForExistingHouseholds < ActiveRecord::Migration[7.2]
  def up
    Household.where(creator_id: nil).find_each do |household|
      # 最も古いmembershipのユーザーをcreatorとして設定
      first_membership = household.memberships.order(created_at: :asc).first
      if first_membership
        household.update_column(:creator_id, first_membership.user_id)
      end
    end
  end

  def down
    # ロールバック時は何もしない（データを削除しない）
  end
end


