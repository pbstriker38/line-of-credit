class AddPeriodStartToUser < ActiveRecord::Migration
  def change
    add_column :users, :period_start, :datetime
  end
end
