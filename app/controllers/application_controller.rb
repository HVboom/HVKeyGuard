class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include HttpAcceptLanguage::AutoLocale

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:name, :email, :login, :password)
    end
  end

  # always show index page after sign in
  def after_sign_in_path_for(resource)
    root_path
  end
end
