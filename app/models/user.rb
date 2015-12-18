class User < ActiveRecord::Base
  include Clearance::User

  monetize :credit_limit_cents
  monetize :balance_cents

  has_many :transactions

  # Balance starts at 0 and goes negative when you borrow money.
  # When updating the balance you should pass in a negative amount
  # for a withdrawal.
  def update_balance(amount)
    self.credit_limit += amount
    self.balance += amount
    self.save
  end

  def valid_transaction?(amount)
    if self.balance + amount > Money.new(0)
      return false
    end

    if self.credit_limit + amount < Money.new(0)
      return false
    end

    return true
  end
end
