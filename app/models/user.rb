class User < ActiveRecord::Base
  include Clearance::User

  monetize :credit_limit_cents
  monetize :balance_cents

  has_many :transactions

end
