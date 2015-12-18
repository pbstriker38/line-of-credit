class Transaction < ActiveRecord::Base
  monetize :amount_cents

  belongs_to :user

  def self.previous_in_period(user, transaction_id)
    user.transactions
      .where("created_at >= ?", user.period_start )
      .where(transaction_type: ['withdraw', 'pay'])
      .where("id < ?", transaction_id)
      .last
  end

  def self.last_non_interest_transaction_in_period(user)
    user.transactions
      .where("created_at >= ?", user.period_start )
      .where(transaction_type: ['withdraw', 'pay'])
      .max_by(&:created_at)
  end
end
