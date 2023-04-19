class Api::V1::AccountController < ::ApiController
  def transactions
    result = ::Accounts::Transactions.run!
    render json: result
  end

  def transfer
    result = ::Accounts::Transfer.run!
    render json: result
  end

  def balance
    result = ::Accounts::Balance.run!(user: current_user)
    render json: result
  end
end
