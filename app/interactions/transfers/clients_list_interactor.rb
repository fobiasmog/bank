module Transfers
  class ClientsListInteractor < ActiveInteraction::Base
    # TODO: pagination
    object :user, class: User

    def execute
      # TODO: query?
      User.joins(:account).where.not(id: user.id).select('users.id, users.name, accounts.iban').order(:id)
    end
  end
end