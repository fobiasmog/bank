# frozen_string_literal: true

module Transfers
  class SendInteractor < ActiveInteraction::Base
    integer :sender_id
    integer :receiver_id
    decimal :amount

    validates :sender_id, :receiver_id, presence: true
    validates_numericality_of :amount, greater_than: 0

    attr_reader :debit_log, :credit_log

    set_callback :execute, :around, ->(_, block) { rescued_execute(block) }

    def execute
      send_to_myself?

      init_transaction_logs!

      swap_money!

      { balance: sender_user.account.reload.balance }
    end

    private

    # rubocop:disable Metrics/MethodLength
    def rescued_execute(block)
      block.call
    rescue ::Errors::WrongReceiver => exception
      catch_error!('No way!', exception: exception)

    rescue ActiveRecord::LockWaitTimeout => exception
      catch_error!('Try again', exception: exception)

    rescue ::Errors::NotEnoughMoney => exception
      catch_error!('Not enough money', target: :sender_id, exception: exception)

    rescue ActiveRecord::RecordNotFound => exception
      catch_error!('Empty user', exception: exception)

    rescue StandardError => exception
      catch_error!('oops something went wrong', exception: exception)
    end
    # rubocop:enable Metrics/MethodLength

    def init_transaction_logs!
      # if second transaction will be rollbacked, we are not loose our history
      ActiveRecord::Base.transaction do
        @debit_log = ::TransactionLogs::DebitLoggerService.new(account: sender_user.account, amount: amount, target_name: receiver_user.name)
        @credit_log = ::TransactionLogs::CreditLoggerService.new(account: receiver_user.account, amount: amount, target_name: sender_user.name)
      end
    end

    def swap_money!
      ActiveRecord::Base.transaction do
        ::Transfers::SwapMoneyService.call(
          sender_account: sender_user.account,
          receiver_account: receiver_user.account,
          amount: amount
        )

        debit_log.complete!
        credit_log.complete!
      end
    end

    def sender_user
      @sender_user ||= User.preload(:account).find(sender_id)
    end

    def receiver_user
      @receiver_user ||= User.preload(:account).find(receiver_id)
    end

    def catch_error!(message, target: 'Error:', exception: nil)
      Rails.logger.error(exception) if exception.present?

      errors.add(target, message)

      debit_log&.failure!
      credit_log&.failure!
    end

    def send_to_myself?
      raise ::Errors::WrongReceiver if sender_user.id == receiver_user.id
    end
  end
end
