class Mymoney::Money
  include Mymoney::Arithmetics
  include Mymoney::Exchange

  # Default precision will be determined
  # by BigDecimal based on provided amount
  DEFAULT_PRECISION = 0

  attr_reader :currency

  def initialize(amount, currency)
    @amount = BigDecimal.new(amount, DEFAULT_PRECISION)
    @currency = currency
  end

  def to_s
    amount = self.amount.to_i == self.amount ? self.amount.to_i : self.amount
    "#{amount} #{@currency}"
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
end
