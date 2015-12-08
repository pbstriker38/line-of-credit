class User < ActiveRecord::Base
  include Clearance::User

  monetize :credit_limit_cents

end
