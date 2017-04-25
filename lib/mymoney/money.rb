class Mymoney::Money
  include Mymoney::Arithmetics

  attr_reader :currency

  def initialize(amount, currency)
    @amount = BigDecimal.new(amount, 0)
    @currency = currency
  end

  def to_s
    "#{self.amount} #{@currency}"
  end

  def inspect
    self.to_s
  end

  def amount
    @amount.round(2, BigDecimal::ROUND_HALF_UP).to_f
  end

  def amount_full
    @amount
  end

  def convert_to(new_currency)
    if Mymoney::EXCHANGE_TABLE[@currency].nil?
      raise Mymoney::NoExchangeRateError, "No rates for current currency #{@currency}"
    end
    if Mymoney::EXCHANGE_TABLE[@currency][new_currency].nil?
      raise Mymoney::NoExchangeRateError, "Can't find rate for #{new_currency}" \
        " to convert from #{@currency}"
    end

    rate = Mymoney::EXCHANGE_TABLE[@currency][new_currency]
    new_amount = @amount * BigDecimal.new(rate, 0)
    Mymoney::Money.new(new_amount, new_currency)
  end
end
