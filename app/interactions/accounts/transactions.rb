module Accounts
  class Transactions < ActiveInteraction::Base
    def execute
      return [
        { type: 'charge', value: 100, user: 'Alice' },
        { type: 'refill', value: 1000, user: 'Bob' },
      ]
    end
  end
end
