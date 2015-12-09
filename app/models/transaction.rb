class Transaction < ActiveRecord::Base
  monetize :amount_cents

  belongs_to :user
end
