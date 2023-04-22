module Accounts
  class TransactionsInteractor < ActiveInteraction::Base
    object :account, class: Account

    def execute
      TransactionLogs::ListQuery.call(account_id: account.id)
    end
  end
end
