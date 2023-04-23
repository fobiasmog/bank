# frozen_string_literal: true

module TransactionLogs
  class ListQuery
    PER_PAGE = 5

    def self.call(account_id:, page: 0)
      TransactionLog
        .where(
          account_id: account_id,
          state: 'completed'
        )
        .order(created_at: :desc)
        .select('amount, kind, state, target_name, created_at')
        .limit(PER_PAGE)
        .offset(page * PER_PAGE)
    end
  end
end
