# frozen_string_literal: true

module Accounts
  class BalanceInteractor < ActiveInteraction::Base
    object :user, class: User

    def execute
      { balance: user.account.balance }
    end
  end
end
