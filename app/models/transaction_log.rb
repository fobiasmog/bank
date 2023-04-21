class TransactionLog < ApplicationRecord
  enum kind: { debit: 'debit', credit: 'credit' }

  state_machine initial: :init do
    event :complete do
      transition :init => :completed
    end

    event :failure do
      transition all => :failed
    end
  end
end
