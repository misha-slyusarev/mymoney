class Mymoney::Money
  attr_reader :amount, :currency

  def initialize(amount, currency)
    @amount = BigDecimal.new(amount)
    @currency = currency
  end

  def to_s
    "#{@amount.to_s('F')} #{@currency}"
  end

  def inspect
    self.to_s
  end

  def convert_to(new_currency)
    if Mymoney::EXCHANGE_TABLE[@currency].nil?
      raise Mymoney::NoExchangeRateError, "No rates for current currency #{@currency}"
    end
    if Mymoney::EXCHANGE_TABLE[@currency][new_currency].nil?
      raise Mymoney::NoExchangeRateError, "Can't find rate for #{new_currency} to convert from #{@currency}"
    end

    rate = Mymoney::EXCHANGE_TABLE[@currency][new_currency]
    @amount = @amount * BigDecimal.new(rate, 2)
    @currency = new_currency
  end
end
