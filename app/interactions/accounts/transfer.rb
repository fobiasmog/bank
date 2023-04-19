module Accounts
  class Transfer < ActiveInteraction::Base
    def execute
      return { balance: 30.10 }
    end
  end
end
