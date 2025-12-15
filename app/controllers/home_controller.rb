# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    # ログイン済みの場合は買い物メモ一覧にリダイレクト
    redirect_to memos_path if user_signed_in?
  end
end


