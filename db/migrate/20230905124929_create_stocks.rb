class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.string :symbol
      t.decimal :current_price

      t.timestamps
    end
  end
end
