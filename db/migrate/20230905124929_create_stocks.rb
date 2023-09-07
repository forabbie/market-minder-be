class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.references :user, null: false, foreign_key: true
      t.string :symbol
      t.string :company_name
      t.decimal :last_price
      t.decimal :shares_quantity, null: false, :default => 0.0

      t.timestamps
    end
  end
end
