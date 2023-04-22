module TransactionLogs
  class ListQuery
    def self.call(account_id:)
      TransactionLog
        .where(
          account_id: account_id,
          state: 'completed'
        )
        .order(created_at: :desc)
        .select('amount, kind, state, target_name, created_at')
        .limit(5)
    end
  end
end
