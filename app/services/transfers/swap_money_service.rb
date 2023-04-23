# frozen_string_literal: true

module Transfers
  class SwapMoneyService
    def self.call(sender_account:, receiver_account:, amount:)
      ActiveRecord::Base.connection.execute "SET lock_timeout TO '1s'" # or, maybe, tune you pg config

      sender_account_with_lock = sender_account.lock!
      raise ::Errors::NotEnoughMoney unless (sender_account_with_lock.balance - amount).positive?

      receiver_account_with_lock = receiver_account.lock!

      sender_account_with_lock.update!(balance: sender_account_with_lock.balance - amount)
      receiver_account_with_lock.update!(balance: receiver_account_with_lock.balance + amount)
    end
  end
end
