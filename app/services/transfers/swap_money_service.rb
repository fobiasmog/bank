module Transfers
  class SwapMoneyService
    def call(sender_user, receiver_user, amount)
      ActiveRecord::Base.transaction do
        sender_account = sender_user.account.lock!
        raise ::Errors::NotEnoughtMoney unless (sender_account.balance - amount).positive?

        receiver_account = receiver_user.account.lock!

        sender_account.balance -= amount
        receiver_account.balance += amount

        sender_account.save!
        receiver_account.save!
      end
    end
  end
end
