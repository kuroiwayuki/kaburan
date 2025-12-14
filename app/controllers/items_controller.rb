# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_current_household
  before_action :set_item

  def toggle_purchased
    @item.update(purchased: !@item.purchased)
    redirect_to root_path, notice: @item.purchased ? "「#{@item.name}」を購入済みにしました" : "「#{@item.name}」の購入済みを解除しました"
  end

  private

  def set_item
    @item = Item.joins(memo: :household)
                .where(households: { id: current_household.id })
                .find_by(id: params[:id])
    
    unless @item
      redirect_to root_path, alert: "アイテムが見つかりませんでした"
    end
  end

  def ensure_current_household
    return if current_household

    redirect_to new_household_path, alert: "家族グループを作成するか、参加してください"
  end
end

