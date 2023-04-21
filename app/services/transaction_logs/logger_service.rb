module TransactionLogs
  class LoggerService
    attr_reader :transaction

    def initialize(account, amount, kind)
      @transaction = TransactionLog.create!(
        account_id: account.id,
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
