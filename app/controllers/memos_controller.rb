# frozen_string_literal: true

class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_household

  def index
    @memos = current_household.memos.includes(:user, :items).order(created_at: :desc)
  end

  private

  def ensure_current_household
    return if current_household

    redirect_to new_household_path, alert: "家族グループを作成するか、参加してください"
  end
end

