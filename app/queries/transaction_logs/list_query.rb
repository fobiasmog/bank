module TransactionLogs
  class ListQuery
    def self.call(account_id)
      TransactionLog
        .joins(:account)
        .where(accounts: { id: account_id })
    end
  end
end
