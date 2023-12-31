class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :account_status, null: false, :default => "pending"
      t.string :role, null: false, :default => "trader"
      t.decimal :fund, null: false, :default => 0.0
      t.string :token
      t.datetime :token_expiration

      t.timestamps
    end
  end
end
