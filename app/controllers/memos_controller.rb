# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_household

  def index
    @memos = current_household.memos.includes(:user, :items).order(created_at: :desc)
  end

  def new
    @memo = current_household.memos.build
    @memo.items.build
  end

  def create
    @memo = current_household.memos.build(memo_params)
    @memo.user = current_user

    if @memo.save
      redirect_to root_path, notice: "買い物メモを作成しました"
    else
      # エラー時は最低1つのItem入力欄を確保
      @memo.items.build if @memo.items.empty?
      render :new, status: :unprocessable_entity
    end
  end

  private

  def ensure_current_household
    return if current_household

    redirect_to new_household_path, alert: "家族グループを作成するか、参加してください"
  end

  def memo_params
    params.require(:memo).permit(items_attributes: [:name, :_destroy])
  end
end

