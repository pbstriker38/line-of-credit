module InterestHelper

  def calculate_interest(user, transaction=nil)
    balance = user.balance.amount * BigDecimal.new('-1')

    return if balance == Money.new(0)

    apr = BigDecimal.new('0.35')
    days_in_year = BigDecimal.new('365')
    days_in_period = BigDecimal.new(days_since_last_transaction(user, transaction))

    interest = balance * apr / days_in_year * days_in_period

    if interest > BigDecimal.new('0')
      Transaction.create(amount: interest, transaction_type: 'interest', user_id: user.id)
    end
  end

  def days_since_last_transaction(user, transaction)
    if transaction
      last_transaction = Transaction.previous_in_period(user, transaction.id)
    else
      last_transaction = Transaction.last_non_interest_transaction_in_period(user)
    end

    if last_transaction.present?
      (Time.zone.now.to_date - last_transaction.created_at.to_date).to_i
    else
      (Time.zone.now.to_date - user.period_start.to_date).to_i
    end
  end
end
