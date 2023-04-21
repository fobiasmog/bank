module Transfers
  class SendInteractor < ActiveInteraction::Base
    integer :sender_id
    integer :receiver_id
    decimal :amount

    validates :sender_id, :receiver_id, presence: true
    validates_numericality_of :amount, greater_than: 0

    attr_reader :transaction_log_service

    def execute
      raise ::Errors::WrongReceiver if sender_user.id == receiver_user.id

      @transaction_log_service = TransactionLogService.new(sender_user, receiver_user, amount)

      begin
        ::Transfers::SwapMoneyService.call(sender_user, receiver_user, amount)
        transaction_log_service.complete!
      rescue ::Errors::NotEnoughtMoney
        catch_error!(:sender_id, "Not enough money")
      end

      return { balance: sender_user.account.balance }

    rescue ActiveRecord::RecordNotFound
      catch_error!("Error:", "No user")
    rescue ::Errors::WrongReceiver
      catch_error!("Error:", "No way!")
    rescue StandardError
      catch_error!("Error:", "oops something went wrong")
    end

    private

    def sender_user
      @sender_user ||= User.preload(:account).find(sender_id)
    end

    def receiver_user
      @receiver_user ||= User.preload(:account).find(receiver_id)
    end

    def catch_error!(target, message)
      errors.add(target, message)
      transaction_log_service.failure!
    end
  end
end
