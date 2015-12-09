class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.money :amount
      t.string :transaction_type
      t.integer :user_id
    end
  end
end
