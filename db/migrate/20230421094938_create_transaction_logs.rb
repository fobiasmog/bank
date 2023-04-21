class CreateTransactionLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_logs do |t|
      # why not null constraint if we created FK?
      # to speed up your PG you can turn off FKs,
      # but you need to make sure, that your app can handle it
      t.bigint :sender_account_id, null: false
      t.bigint :receiver_account_id, null: false
      t.decimal :amount, null: false
      t.string :status, default: 'init'
      t.string :key, null: false

      t.timestamps
    end

    add_foreign_key :transaction_logs, :accounts, column: :sender_account_id, primary_key: :id
    add_foreign_key :transaction_logs, :accounts, column: :receiver_account_id, primary_key: :id
  end
end
