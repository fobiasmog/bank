# frozen_string_literal: true

module TransactionLogs
  class LoggerService
    attr_reader :transaction

    def initialize(account:, amount:, kind:, target_name:)
      @transaction = TransactionLog.create!(
        account_id: account.id,
        target_name: target_name,
        amount: amount,
        kind: kind
      )
    end

    def complete!
      transaction.complete!
    end

    def failure!
      transaction.failure!
    end
  end
end
