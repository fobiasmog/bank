module TransactionLogs
  class DebitLoggerService < LoggerService
    def initialize(account, amount)
      super(account, amount, 'debit')
    end
  end
end
