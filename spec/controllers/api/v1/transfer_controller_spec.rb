require 'rails_helper'

RSpec.describe Api::V1::TransferController, type: :controller do
  let_it_be(:sender) { create(:user) }
  let_it_be(:receiver) { create(:user) }
  let(:amount) { 100 }

  before do
    # Set the current user
    allow(controller).to receive(:current_user).and_return(sender)

    # Stub the SendInteractor to avoid making real transfers
    allow(Transfers::SendInteractor).to receive(:run)
  end

  describe '#transfer_money' do
    subject(:transfer_money) { post :transfer_money, params: params }

    let(:params) do
      {
        transfer: {
          receiver_id: receiver.id,
          amount: amount
        }
      }
    end

    let(:transfer_result) { { balance: 1 } }

    context 'when the transaction is valid' do
      let(:transaction) { double('transaction', valid?: true, result: transfer_result) }

      before do
        allow(Transfers::SendInteractor).to receive(:run).and_return(transaction)
      end

      it 'returns a successful response' do
        transfer_money

        expect(response).to have_http_status(:success)
        expect(response.body).to eq(transfer_result.to_json)
      end
    end

    context 'when the transaction is invalid' do
      let(:transaction) do
        double(
          'transaction',
          valid?: false,
          errors: double(full_messages: ['Error message'])
        )
      end

      before do
        allow(Transfers::SendInteractor).to receive(:run).and_return(transaction)
      end

      it 'returns an error response with status 500' do
        transfer_money

        expect(response).to have_http_status(500)
        expect(JSON.parse(response.body)).to eq('errors' => ['Error message'])
      end
    end
  end
end
