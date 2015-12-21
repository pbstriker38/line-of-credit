require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#set_up_user' do
    before(:all) do
      @user = User.new(
        first_name: 'Bill',
        last_name: 'Miller',
        email: 'bill.miller@example.com',
        password: 'password'
      )
      @user.set_up_user
    end

    it "sets the credit_limit to $1000" do
      expect(@user.credit_limit).to eq(Money.new(100000))
    end

    it "sets the balance to $0" do
      expect(@user.balance).to eq(Money.new(0))
    end

    it "sets the period_start to the beginning of today" do
      beginning_of_day = Time.zone.now.beginning_of_day
      expect(@user.period_start).to eq(beginning_of_day)
    end
  end

  describe '#update_balance' do
    let(:user) {
      User.create(
        first_name: 'Bill',
        last_name: 'Miller',
        email: 'bill.miller@example.com',
        password: 'password'
      )
    }

    context "when withdrawing" do
      before do
        user.update_balance(Money.new(-20000))
      end

      it "reduces the credit limit by the amount" do
        expect(user.credit_limit).to eq(Money.new(80000))
      end

      it "increases the balance by the amount" do
        expect(user.balance).to eq(Money.new(-20000))
      end
    end

    context "when paying" do
      before do
        user.update_balance(Money.new(20000))
      end

      it "increases the credit limit by the amount" do
        expect(user.credit_limit).to eq(Money.new(120000))
      end

      it "reduces the balance by the amount" do
        expect(user.balance).to eq(Money.new(20000))
      end
    end
  end

  describe '#valid_transaction?' do
    let(:user) {
      User.create(
        first_name: 'Bill',
        last_name: 'Miller',
        email: 'bill.miller@example.com',
        password: 'password'
      )
    }

    context "when trying to withdraw more than credit limit" do
      it "returns false" do
        expect(user.valid_transaction?(Money.new(-200000))).to eq(false)
      end
    end

    context "when trying to pay more than balance" do
      it "returns false" do
        expect(user.valid_transaction?(Money.new(20000))).to eq(false)
      end
    end

    context "when not overdrawing or overpaying" do
      it "returns true" do
        expect(user.valid_transaction?(Money.new(-20000))).to eq(true)
      end
    end
  end
end
