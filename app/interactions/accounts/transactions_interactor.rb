module Accounts
  class TransactionsInteractor < ActiveInteraction::Base
    object :account, class: Account
    integer :page, default: 0

    def execute
      TransactionLogs::ListQuery.call(account_id: account.id, page: page)
    end
  end
end
