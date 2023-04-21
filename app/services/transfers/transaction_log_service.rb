module Transfers
  class TransactionLogService
    attr_reader :transaction
    def initialize(sender_user, receiver_user, amount)
      @transaction = Transaction.create!(
        sender_account_id: sender_user.account.id,
        receiver_account_id: receiver_user.account.id,
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
