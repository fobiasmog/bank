module Accounts
  class TransactionsInteractor < ActiveInteraction::Base
    object :account, class: Account

    def execute
      TransactionLog.where(account_id: account.id).order(created_at: :desc).select('amount, kind, state, target_name, created_at').limit(5)
    end
  end
end
