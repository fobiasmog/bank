class Api::V1::AccountController < ::ApiController
  def transactions
    result = ::Accounts::TransactionsInteractor.run!(account: current_user.account)
    render partial: 'partials/transactions', locals: { transactions: result }
  end

  def balance
    result = ::Accounts::BalanceInteractor.run!(user: current_user)
    render json: result
  end
end
