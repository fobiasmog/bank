# frozen_string_literal: true

class CreateTransactionLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_logs do |t|
      # why not null constraint for user_id if we created FK?
      # to speed up your PG you can turn off FKs,
      # but you need to make sure, that your app can handle it
      t.bigint :account_id, null: false
      t.decimal :amount, null: false
      t.string :state, null: false
      t.string :kind, null: false

      t.timestamps
    end

    add_foreign_key :transaction_logs, :accounts, column: :account_id, primary_key: :id
  end
end
