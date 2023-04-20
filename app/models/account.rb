class Account < ApplicationRecord
  belongs_to :user

  before_create do
    self.iban = FFaker::Bank.iban
  end
end
