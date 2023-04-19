class ApplicationController < ActionController::Base
  def index
    # pp current_user
  end

  def current_user
    return unless session.key?(:userinfo)

    @current_user ||= User.find_by(email: session[:userinfo][:email])
  end
end
