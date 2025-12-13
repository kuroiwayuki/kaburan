# frozen_string_literal: true

class HouseholdsController < ApplicationController
  before_action :authenticate_user!

  def new
    @household = Household.new
  end

  def create
    @household = Household.new(household_params)

    if @household.save
      # 作成者を自動的にMembershipに追加
      @household.memberships.create!(user: current_user)
      redirect_to root_path, notice: "家族グループ「#{@household.name}」を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def household_params
    params.require(:household).permit(:name)
  end
end

