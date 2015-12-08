class AddBalanceToUser < ActiveRecord::Migration
  def change
    add_money :users, :balance
  end
end
