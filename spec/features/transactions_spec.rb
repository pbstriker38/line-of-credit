require "rails_helper"

RSpec.feature "Transactions", :type => :feature do
  scenario "User borrows $500 on day one" do
    user = User.create(first_name: 'Bill', last_name: 'Miller', email: 'bill.miller@example.com', password: 'password')

    visit root_path(as: user)

    click_link 'Withdraw'

    fill_in 'Amount', with: '500.00'

    click_button 'Create Transaction'

    Timecop.travel(Date.today + 31.days) do
      # In reality this would be a scheduled job. For simplicity I will
      # just call this method manually
      user.reload.close_period
    end

    expect(user.balance).to eq(Money.new(-51438))
  end

  scenario "User borrows $500 on day one, pays back $200 on day 15, and draws another $100 on day 25" do
    user = User.create(first_name: 'Bill', last_name: 'Miller', email: 'bill.miller@example.com', password: 'password')

    visit root_path(as: user)

    click_link 'Withdraw'

    fill_in 'Amount', with: '500.00'

    click_button 'Create Transaction'

    Timecop.travel(Date.today + 16.days) do
      visit root_path(as: user)

      click_link 'Pay'

      fill_in 'Amount', with: '200.00'

      click_button 'Create Transaction'
    end

    Timecop.travel(Date.today + 26.days) do
      visit root_path(as: user)

      click_link 'Withdraw'

      fill_in 'Amount', with: '100.00'

      click_button 'Create Transaction'
    end

    Timecop.travel(Date.today + 31.days) do
      # In reality this would be a scheduled job. For simplicity I will
      # just call this method manually
      user.reload.close_period
    end

    expect(user.balance).to eq(Money.new(-41199))
  end
end
