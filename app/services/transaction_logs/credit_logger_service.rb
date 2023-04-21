module TransactionLogs
  class CreditLoggerService < LoggerService
    def initialize(account, amount)
      super(account, amount, 'credit')
    end
  end
end
