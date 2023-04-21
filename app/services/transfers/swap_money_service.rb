module Transfers
  class SwapMoneyService
    def self.call(sender_account_id, receiver_account_id, amount)
      ActiveRecord::Base.connection.execute "SET lock_timeout TO '1s'" # or, maybe, tune you pg config

      sender_account = Account.find(sender_account_id).lock!
      raise ::Errors::NotEnoughMoney unless (sender_account.balance - amount).positive?

      receiver_account = Account.find(receiver_account_id).lock!

      sender_account.update!(balance: sender_account.balance - amount)
      receiver_account.update!(balance: receiver_account.balance + amount)
    end
  end
end
