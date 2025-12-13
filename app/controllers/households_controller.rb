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

  def join
    @invite_code = params[:invite_code] || ""
  end

  def join_create
    @invite_code = params[:invite_code]&.upcase&.strip

    if @invite_code.blank?
      flash.now[:alert] = "招待コードを入力してください"
      render :join, status: :unprocessable_entity
      return
    end

    @household = Household.find_by(invite_code: @invite_code)

    if @household.nil?
      flash.now[:alert] = "招待コードが見つかりませんでした"
      render :join, status: :unprocessable_entity
      return
    end

    # 既に参加済みかチェック
    if current_user.households.include?(@household)
      flash.now[:alert] = "既に「#{@household.name}」に参加しています"
      render :join, status: :unprocessable_entity
      return
    end

    # Membershipを作成
    membership = @household.memberships.build(user: current_user)
    if membership.save
      redirect_to root_path, notice: "家族グループ「#{@household.name}」に参加しました"
    else
      flash.now[:alert] = "参加に失敗しました"
      render :join, status: :unprocessable_entity
    end
  end

  private

  def household_params
    params.require(:household).permit(:name)
  end
end

