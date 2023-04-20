class ApplicationController < ActionController::Base
  def index
    @user = current_user

    if current_user
      @account = current_user&.account
      @clients_list = ::Transfers::ClientsListInteractor.run!(user: current_user)
    end
  end

  def current_user
    return unless session.key?(:userinfo)

    @current_user ||= User.find_by(email: session.dig('userinfo', 'email'))
  end
end
