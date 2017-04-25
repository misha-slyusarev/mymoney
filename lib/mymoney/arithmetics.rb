module Mymoney::Arithmetics
  [:+, :-].each do |op|
    define_method(op) do |other|
      raise TypeError unless other.is_a?(Mymoney::Money)
      other = other.convert_to(currency) unless currency == other.currency
      Mymoney::Money.new(amount_full.public_send(op, other.amount_full), currency)
    end
  end

  [:/, :*].each do |op|
    define_method(op) do |other|
      raise TypeError unless other.is_a?(Numeric)
      Mymoney::Money.new(amount_full.public_send(op, other), currency)
    end
  end
end
