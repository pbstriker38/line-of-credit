class User < ActiveRecord::Base
  include Clearance::User
  include InterestHelper

  monetize :credit_limit_cents
  monetize :balance_cents

  has_many :transactions

  before_create :set_up_user

  def set_up_user
    self.credit_limit = Money.new(100000)
    self.balance = Money.new(0)
    self.period_start = Time.zone.now.beginning_of_day
  end

  # Balance starts at 0 and goes negative when you borrow money.
  # When updating the balance you should pass in a negative amount
  # for a withdrawal.
  def update_balance(amount)
    self.credit_limit += amount
    self.balance += amount
    self.save
  end

  def close_period
    calculate_interest(self)

    # interest_for_period is made negative because it is money owed.
    total_interest = -interest_for_period
    Transaction.create(amount: total_interest, transaction_type: 'period interest', user_id: self.id)

    update_balance(total_interest)
    reset_period_start
  end

  def interest_for_period
    interest_transactions = transactions
                            .where("created_at >= ?", self.period_start )
                            .where(transaction_type: ['interest'])

    interest = Money.new(0)
    interest_transactions.each do |transaction|
      interest += transaction.amount
    end

    return interest
  end

  def reset_period_start
    self.period_start = Time.zone.now.beginning_of_day
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
