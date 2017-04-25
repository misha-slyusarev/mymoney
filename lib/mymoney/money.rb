class Mymoney::Money
  include Mymoney::Arithmetics
  include Mymoney::Exchange

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
end
