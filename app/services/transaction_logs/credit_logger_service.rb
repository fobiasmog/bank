module TransactionLogs
  class CreditLoggerService < LoggerService
    def initialize(account:, amount:, target_name:)
      super(
        account: account,
        amount: amount,
        target_name: target_name,
        kind: 'credit'
      )
    end
  end
end
