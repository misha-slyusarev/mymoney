class Mymoney::NoExchangeRateError < StandardError
  def initialize(msg = 'Exchange rate not found')
    super(msg)
  end
end
