require 'rails_helper'

RSpec.describe TransactionLogs::CreditLoggerService do
  describe '.new' do
    subject { described_class.new(**params) }

    let(:params) do
      {
        account: Account.new,
        amount: 100.1,
        target_name: "Name"
      }
    end

    it 'creates TransactionLog record with kind == credit' do
      expect(TransactionLog)
        .to receive(:create!)
        .with(hash_including(kind: 'credit'))
        .and_return(true)

      subject
    end
  end
end
