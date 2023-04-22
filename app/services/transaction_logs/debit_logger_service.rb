# frozen_string_literal: true

module TransactionLogs
  class DebitLoggerService < LoggerService
    def initialize(account:, amount:, target_name:)
      super(
        account: account,
        amount: amount,
        target_name: target_name,
        kind: 'debit'
      )
    end
  end
end
