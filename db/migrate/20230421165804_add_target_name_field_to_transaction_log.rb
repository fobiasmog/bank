class AddTargetNameFieldToTransactionLog < ActiveRecord::Migration[7.0]
  def change
    add_column :transaction_logs, :target_name, :string, null: false
  end
end
