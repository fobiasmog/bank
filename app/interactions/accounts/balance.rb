module Accounts
  class Balance < ActiveInteraction::Base
    object :user, class: User

    def execute
      return { balance: user.account.balance }
    end
  end
end
