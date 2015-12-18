class TransactionsController < ApplicationController
  before_action :require_login

  def index
    @transactions = current_user.transactions
  end

  # POST /transactions
  def create

    @transaction = Transaction.new(transaction_params)
    @transaction.user_id = current_user.id

    respond_to do |format|
      if @transaction.amount > Money.new(0, 'USD')
        if @transaction.save
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
