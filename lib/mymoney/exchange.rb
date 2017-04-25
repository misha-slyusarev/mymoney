module Mymoney::Exchange
  EXCHANGE_TABLE = {}

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def exchange_rates(currency, rates)
      if EXCHANGE_TABLE[currency].nil?
        EXCHANGE_TABLE[currency] = rates
      else
        EXCHANGE_TABLE[currency].merge!(rates)
      end
    end
  end

  def convert_to(new_currency)
    if EXCHANGE_TABLE[@currency].nil?
      raise Mymoney::NoExchangeRateError, "No rates for current currency #{@currency}"
    end
    if EXCHANGE_TABLE[@currency][new_currency].nil?
      raise Mymoney::NoExchangeRateError, "Can't find rate for #{new_currency}" \
        " to convert from #{@currency}"
    end

    rate = EXCHANGE_TABLE[@currency][new_currency]
    new_amount = @amount * BigDecimal.new(rate, Mymoney::Money::DEFAULT_PRECISION)
    Mymoney::Money.new(new_amount, new_currency)
  end
end
