class TransactionsController < ApplicationController
  include InterestHelper

  before_action :require_login

  def index
    @transactions = current_user.transactions
  end

  # POST /transactions
  def create

    @transaction = Transaction.new(transaction_params)
    if @transaction.transaction_type == 'withdraw'
      @transaction.amount = @transaction.amount.amount * BigDecimal.new('-1')
    end
    @transaction.user_id = current_user.id

    respond_to do |format|
      if @transaction.amount > Money.new(0, 'USD')
      if @transaction.amount != Money.new(0)
        if @transaction.save

          calculate_interest(current_user, @transaction)

          current_user.update_balance(@transaction.amount)
          format.html { redirect_to transactions_path, notice: 'Transaction was successfully completed.' }
        end
      else
        format.html { redirect_to :back, flash: {error: 'An amount is required'} }
      end
    end
  end

  def withdraw
    @transaction = Transaction.new(transaction_type: 'withdraw')
  end

  def pay
    @transaction = Transaction.new(transaction_type: 'pay')
  end

  private
    def transaction_params
      params.require(:transaction).permit(:amount, :transaction_type)
    end
end
