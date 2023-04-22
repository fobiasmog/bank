# frozen_string_literal: true

module Api
  module V1
    class TransferController < ::ApiController
      def transfer_money
        transaction = ::Transfers::SendInteractor.run(**transfer_params)

        unless transaction.valid?
          errors = transaction.errors.full_messages
          return render json: { errors: errors }, status: 500
        end

        render json: transaction.result
      end

      private

      def transfer_params
        {
          **params.require(:transfer).permit(:receiver_id, :amount),
          sender_id: current_user.id
        }
      end
    end
  end
end
