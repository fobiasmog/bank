FactoryBot.define do
  factory :account do
    user_id { FFaker::Number.unique.number }
    iban { FFaker::Bank.iban }
    balance { 1000.1 }
  end
end
