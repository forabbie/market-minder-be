class AddCashBalanceToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :cash_balance, :float, null: false, :default => 0.0
  end
end
