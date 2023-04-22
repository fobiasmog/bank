require 'rails_helper'

RSpec.describe Auth::CreateUserInteractor do
  describe '#execute' do
    subject { described_class.run!(**params) }

    let(:params) do
      {
        email: new_user.email,
        name: new_user.name,
        avatar_url: new_user.avatar_url
      }
    end

    let(:new_user)  { build(:user) }

    context 'when user does not exist' do
      it 'creates a new user and account' do
        expect { subject }
          .to change(User, :count).by(1)
          .and change(Account, :count).by(1)
      end
    end

    context 'when user already exists' do
      let!(:existing_user) { create(:user) }
      let(:params) do
        {
          email: existing_user.email,
          name: existing_user.name,
          avatar_url: existing_user.avatar_url
        }
      end

      it 'does not create a new user' do
        expect { subject }.not_to change(User, :count)
      end

      context 'when account already exists' do
        let!(:existing_account) { create(:account, user_id: existing_user.id) }

        it 'does not create a new account' do
          expect { subject }.not_to change(Account, :count)
        end
      end

      context 'when account does not exist' do
        it 'creates a new account for the user' do
          expect { subject }.to change(Account, :count).by(1)
        end
      end
    end
  end
end
