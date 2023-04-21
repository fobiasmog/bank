module Accounts
  class BalanceInteractor < ActiveInteraction::Base
    object :user, class: User

    def execute
      return { balance: user.account.balance }
    end
  end
end
