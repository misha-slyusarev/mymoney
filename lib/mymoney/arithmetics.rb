module Mymoney::Arithmetics
  [:+, :-].each do |op|
    define_method(op) do |other|
      raise TypeError unless other.is_a?(Mymoney::Money)
      other = other.convert_to(currency) unless currency == other.currency
      self.class.new(amount_full.public_send(op, other.amount_full), currency)
    end
  end

# fifty_eur - twenty_dollars # => 31.98 EUR
# fifty_eur / 2              # => 25 EUR
# twenty_dollars * 3         # => 60 USD
end
