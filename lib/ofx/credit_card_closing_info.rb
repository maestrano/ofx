module OFX
  class CreditCardClosingInfo < Foundation
    attr_accessor :account_id
    attr_accessor :currency_default

    attr_accessor :fit_id
    attr_accessor :date_close

    attr_accessor :opening_balance
    attr_accessor :closing_balance
    attr_accessor :payment_due_date
    attr_accessor :minimum_due_amount

    attr_accessor :last_payment_date
    attr_accessor :last_payment_amount
  end
end
