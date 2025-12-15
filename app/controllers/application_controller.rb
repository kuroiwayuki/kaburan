class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_household, if: :user_signed_in?

  helper_method :current_household

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name ])
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def current_household
    @current_household
  end

  def set_current_household
    return unless user_signed_in?

    household_id = session[:household_id]
    @current_household = if household_id
      current_user.households.find_by(id: household_id)
    end

    # セッションにhousehold_idがない、または見つからない場合は最初のHouseholdを選択
    @current_household ||= current_user.households.first
  end
end