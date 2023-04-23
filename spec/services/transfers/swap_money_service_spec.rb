# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Transfers::SwapMoneyService do
  describe '.call' do
    subject { described_class.call(**params) }

    let(:params) do
      {
        sender_account: sender,
        receiver_account: receiver,
        amount: amount
      }
    end
    let(:amount) { 500 }

    let(:sender_user) { create(:user) }
    let(:receiver_user) { create(:user) }
    let(:sender) { create(:account, user_id: sender_user.id, balance: 1000) }
    let(:receiver) { create(:account, user_id: receiver_user.id, balance: 1000) }

    shared_examples 'transfers money from sender to receiver' do
      it 'successfully' do
        expect { subject }
          .to change { sender.reload.balance }.by(-amount)
          .and change { receiver.reload.balance }.by(amount)
      end
    end

    context 'when sender has enough money' do
      it_behaves_like 'transfers money from sender to receiver'
    end

    context 'when sender does not have enough money' do
      let(:amount) { 1500 }

      it 'raises a NotEnoughMoney error and not change the sender or receiver balance' do
        expect { subject }
          .to raise_error(::Errors::NotEnoughMoney)
          .and not_change { sender.reload.balance }
          .and not_change { receiver.reload.balance }
      end
    end

    context 'when sender send all money' do
      let(:amount) { sender.balance }

      it_behaves_like 'transfers money from sender to receiver'
    end

    context 'when there is a lock timeout' do
      before do
        # rubocop:disable RSpec/AnyInstance
        allow_any_instance_of(ActiveRecord::Locking::Pessimistic).to receive(:lock!).and_raise(ActiveRecord::LockWaitTimeout)
        # rubocop:enable RSpec/AnyInstance
      end

      it 'raises a LockWaitTimeout error and not change the sender or receiver balance' do
        expect { subject }
          .to raise_error(ActiveRecord::LockWaitTimeout)
          .and not_change { sender.reload.balance }
          .and not_change { receiver.reload.balance }
      end
    end
  end
end
