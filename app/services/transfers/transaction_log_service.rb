module Transfers
  class TransactionLogService
    attr_reader :transaction
    def initialize(sender_user, receiver_user, amount)
      @transaction = Transaction.create(
        sender_account: sender_user.account,
        receiver_account: receiver_user.account,
        amount: amount,
        key: SecureRandom.uuid
      )
    end

    private

    def complete!
      transaction.complete!
    end

    def failure!
      transaction.failure!
    end
  end
end
