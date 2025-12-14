# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_household

  def index
    if current_household
      @memos = current_household.memos.includes(:user, :items).order(created_at: :desc)
    else
      @memos = []
    end
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

  def edit
    @memo = current_household.memos.find(params[:id])
    # 既存のItemsがない場合は最低1つの入力欄を確保
    @memo.items.build if @memo.items.empty?
  end

  def update
    @memo = current_household.memos.find(params[:id])

    if @memo.update(memo_params)
      redirect_to root_path, notice: "買い物メモを更新しました"
    else
      # エラー時は最低1つのItem入力欄を確保
      @memo.items.build if @memo.items.empty?
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @memo = current_household.memos.find(params[:id])
    
    # 作成者のみが削除可能
    unless @memo.user == current_user
      redirect_to root_path, alert: "この買い物メモを削除する権限がありません"
      return
    end
    
    @memo.destroy
    redirect_to root_path, notice: "買い物メモを削除しました"
  end

  private

  def ensure_current_household
    # indexアクションの場合はHouseholdがなくても表示可能
    return if current_household || action_name == 'index'
    
    redirect_to root_path, alert: "家族グループを作成するか、参加してください"
  end

  def memo_params
    params.require(:memo).permit(:title, :reason, items_attributes: [:id, :name, :quantity, :_destroy])
  end
end

