# frozen_string_literal: true

class AddIbanToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :iban, :string, limit: 34
  end
end
