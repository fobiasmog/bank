module Accounts
  class Balance < ActiveInteraction::Base
    def execute
      return { balance: 100.01 }
    end
  end
end
