module Transfers
  class SendInteractor < ActiveInteraction::Base
    class NotEnoughtMoney < StandardError; end

    integer :sender_id
    integer :receiver_id
    decimal :amount

    validates :sender_id, :receiver_id, presence: true
    validates_numericality_of :amount, greater_than: 0

    def execute
      ActiveRecord::Base.transaction do
        sender_account = sender_user.account.lock!
        raise NotEnoughtMoney unless (sender_account.balance - amount).positive?

        receiver_account = receiver_user.account.lock!

        sender_account.balance -= amount
        receiver_account.balance += amount

        sender_account.save!
        receiver_account.save!
      end

      return { balance: sender_user.account.balance }
    rescue NotEnoughtMoney
      errors.add(:sender_id, "Not enough money")
    rescue ActiveRecord::RecordNotFound
      errors.add("Error:", "No user")
    end

    private

    def sender_user
      @sender_user ||= User.find(sender_id)
    end

    def receiver_user
      @receiver_user ||= User.find(receiver_id)
    end
  end
end
