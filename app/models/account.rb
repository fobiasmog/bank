class Account < ApplicationRecord
  # belongs_to :user # -- don't really need this right now, coz it adds +1 request per update (select from users)

  before_create do
    self.iban = FFaker::Bank.iban
  end
end
