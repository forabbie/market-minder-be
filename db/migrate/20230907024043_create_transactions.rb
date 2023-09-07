class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :stock, null: false, foreign_key: true
      t.decimal :shares_quantity, null: false, :default => 0.0
      t.decimal :price, null: false, :default => 0.0
      t.decimal :total_price, null: false, :default => 0.0
      t.string :transaction_type

      t.timestamps
    end
  end
end
