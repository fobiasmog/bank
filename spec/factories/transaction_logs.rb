FactoryBot.define do
  factory :transaction_log do
    amount { 100 }
    target_name { 'Name' }
    kind { TransactionLog.kinds['credit'] }
  end
end
