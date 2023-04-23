# frozen_string_literal: true

class AddIndexesConstraintsFks < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :email
    add_check_constraint :accounts, 'balance >= 0', name: 'balance_positiveness_check'
    add_check_constraint :transaction_logs, 'amount >= 0', name: 'amount_positiveness_check'
    add_foreign_key :accounts, :users, column: :user_id, primary_key: :id
  end
end
