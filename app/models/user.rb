class User < ActiveRecord::Base
  include Clearance::User

  monetize :credit_limit_cents
  monetize :balance_cents

end
