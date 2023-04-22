# frozen_string_literal: true

module Api
  module V1
    class AccountController < ::ApiController
      def transactions
        result = ::Accounts::TransactionsInteractor.run!(account: current_user.account, page: params[:page])
        render partial: 'partials/transactions', locals: { transactions: result }
      end

      def balance
        result = ::Accounts::BalanceInteractor.run!(user: current_user)
        render json: result
      end
    end
  end
end
