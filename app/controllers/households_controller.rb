# frozen_string_literal: true

class HouseholdsController < ApplicationController
  before_action :authenticate_user!

  def new
    @household = Household.new
  end

  def create
    @household = Household.new(household_params)
    @household.creator = current_user

    if @household.save
      # 作成者を自動的にMembershipに追加
      @household.memberships.create!(user: current_user)
      # 作成したHouseholdを自動的に選択
      session[:household_id] = @household.id
      redirect_to household_path(@household), notice: "家族グループ「#{@household.name}」を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @household = current_user.households.find_by(id: params[:id])
    
    unless @household
      redirect_to root_path, alert: "家族グループが見つかりませんでした"
    end
  end

  def destroy
    @household = current_user.households.find_by(id: params[:id])

    unless @household
      redirect_to root_path, alert: "家族グループが見つかりませんでした"
      return
    end

    # 作成者のみが削除可能
    unless @household.created_by?(current_user)
      redirect_to root_path, alert: "このグループを削除する権限がありません"
      return
    end

    household_name = @household.name
    @household.destroy

    # 削除したHouseholdが現在選択中のHouseholdだった場合、セッションを更新
    if session[:household_id] == params[:id].to_s
      next_household = current_user.households.first
      if next_household
        session[:household_id] = next_household.id
      else
        session[:household_id] = nil
      end
    end

    redirect_to root_path, notice: "「#{household_name}」を削除しました"
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
      # 参加したHouseholdを自動的に選択
      session[:household_id] = @household.id
      redirect_to root_path, notice: "家族グループ「#{@household.name}」に参加しました"
    else
      flash.now[:alert] = "参加に失敗しました"
      render :join, status: :unprocessable_entity
    end
  end

  def switch
    household = current_user.households.find_by(id: params[:household_id])

    if household.nil?
      redirect_to root_path, alert: "選択した家族グループが見つかりませんでした"
      return
    end

    session[:household_id] = household.id
    redirect_to root_path, notice: "「#{household.name}」に切り替えました"
  end

  def leave
    household = current_user.households.find_by(id: params[:household_id])

    if household.nil?
      redirect_to root_path, alert: "家族グループが見つかりませんでした"
      return
    end

    # 退会するHouseholdの名前を保存
    household_name = household.name

    # Membershipを削除
    membership = current_user.memberships.find_by(household: household)
    if membership
      membership.destroy

      # 退会したHouseholdが現在選択中のHouseholdだった場合、セッションを更新
      if session[:household_id] == household.id.to_s
        # 他のHouseholdがあれば最初のものを選択、なければnil
        next_household = current_user.households.first
        if next_household
          session[:household_id] = next_household.id
        else
          session[:household_id] = nil
        end
      end

      redirect_to root_path, notice: "「#{household_name}」から退会しました"
    else
      redirect_to root_path, alert: "退会に失敗しました"
    end
  end

  private

  def household_params
    params.require(:household).permit(:name)
  end
end

