module Transfers
  class SendInteractor < ActiveInteraction::Base
    integer :sender_id
    integer :receiver_id
    decimal :amount

    validates :sender_id, :receiver_id, presence: true
    validates_numericality_of :amount, greater_than: 0

    attr_reader :debit_log, :credit_log

    def execute
      raise ::Errors::WrongReceiver if sender_user.id == receiver_user.id

      # if second transaction will be rollbacked, we are not loose our history
      ActiveRecord::Base.transaction do
        @debit_log = ::TransactionLogs::DebitLoggerService.new(sender_user.account, amount)
        @credit_log = ::TransactionLogs::CreditLoggerService.new(receiver_user.account, amount)
      end

      ActiveRecord::Base.transaction do
        ::Transfers::SwapMoneyService.call(sender_user.account.id, receiver_user.account.id, amount)

        debit_log.complete!
        credit_log.complete!
      end

      return { balance: sender_user.account.reload.balance }

    rescue ActiveRecord::LockWaitTimeout => exception
      catch_error!("Try again", exception: exception)

    rescue ::Errors::NotEnoughMoney => exception
      catch_error!("Not enough money", target: :sender_id, exception: exception)

    rescue ActiveRecord::RecordNotFound => exception
      catch_error!("No user", exception: exception)

    rescue ::Errors::WrongReceiver => exception
      catch_error!("No way!", exception: exception)

    rescue StandardError => exception
      catch_error!("oops something went wrong", exception: exception)
    end

    private

    def sender_user
      @sender_user ||= User.preload(:account).find(sender_id)
    end

    def receiver_user
      @receiver_user ||= User.preload(:account).find(receiver_id)
    end

    def catch_error!(message, target: "Error:", exception: nil)
      Rails.logger.error(exception) if exception.present?

      errors.add(target, message)

      debit_log&.failure!
      credit_log&.failure!
    end
  end
end
