require 'spec_helper'

describe Mymoney::Arithmetics do
  Money = Mymoney::Money

  let(:rates) { {'USD' => 1.1, 'Bitcoin' => 0.98} }
  let(:currency) { 'EUR' }
  let(:other_currency) { 'CAD' }

  describe '#+' do
    context 'with the same currency' do
      it 'should add other amount to current amount' do
        sum = Money.new(1, currency) + Money.new(2, currency)
        expect(sum).to eq Money.new(3, currency)
      end
    end

    context 'with different currency' do
      let(:other) { Money.new(1, other_currency) }

      context 'with known exchange rates' do
        before do
          Money.exchange_rates(currency, { other_currency => 1.1 })
        end
        it 'should convert other amount and add it to current amount' do
          allow(other).to receive(:convert_to).with(currency).and_return(Money.new(2, currency))
          expect(Money.new(1, currency) + other).to eq(Money.new(3, currency))
        end
        after do
          Money::EXCHANGE_TABLE.delete(currency)
        end
      end

      context 'without exchange rates' do
        it 'should raise NoExchangeRateError' do
          expect{Money.new(1, currency) + other}.to raise_error(Mymoney::NoExchangeRateError)
        end
      end
    end

    context 'when other argument is not Money' do
      it 'raises TypeError' do
        expect{Money.new(1, currency) + 1}.to raise_error(TypeError)
        expect{Money.new(1, currency) + Object.new}.to raise_error(TypeError)
      end
    end
  end

  describe '#-' do
    context 'with the same currency' do
      it 'should subtract other amount from current amount' do
        subst = Money.new(10, currency) - Money.new(5, currency)
        expect(subst).to eq(Money.new(5, currency))
      end
    end

    context 'with different currency' do
      let(:other) { Money.new(1, other_currency) }

      context 'with known exchange rates' do
        before do
          Money.exchange_rates(currency, { other_currency => 1.1 })
        end
        it 'should convert other amount and substract it from current amount' do
          allow(other).to receive(:convert_to).with(currency).and_return(Money.new(2, currency))
          expect(Money.new(3, currency) - other).to eq(Money.new(1, currency))
        end
        after do
          Money::EXCHANGE_TABLE.delete(currency)
        end
      end

      context 'without exchange rates' do
        it 'should raise NoExchangeRateError' do
          expect{Money.new(1, currency) - other}.to raise_error(Mymoney::NoExchangeRateError)
        end
      end
    end

    context 'when other argument is not Money' do
      it 'raises TypeError' do
        expect{Money.new(1, currency) - 1}.to raise_error(TypeError)
        expect{Money.new(1, currency) - Object.new}.to raise_error(TypeError)
      end
    end
  end

  describe '#*' do
    let(:current) { Money.new(1, currency) }

    it 'should multiply Money by Numeric and return Money' do
      expect(current * 10).to eq(Money.new(10, currency))
    end

    context 'when other argument is not Numeric' do
      it 'raises TypeError' do
        expect{current * current}.to raise_error(TypeError)
        expect{current * Object.new}.to raise_error(TypeError)
      end
    end
  end

  describe '#/' do
    let(:current) { Money.new(10, currency) }

    it 'should multiply Money by Numeric and return Money' do
      expect(current / 2).to eq(Money.new(5, currency))
    end

    context 'when other argument is not Numeric' do
      it 'raises TypeError' do
        expect{current / current}.to raise_error(TypeError)
        expect{current / Object.new}.to raise_error(TypeError)
      end
    end
  end

  describe '#>' do
    context 'with the same currencies' do
      let(:bigger) { Money.new(10, currency) }
      let(:less) { Money.new(1, currency) }

      it 'returns true when first amount is bigger then the second' do
        expect(bigger > less).to be true
      end
      it 'returns false when first amount is less then the second' do
        expect(less > bigger).to be false
      end
    end

    context 'with different currencies' do
      let(:bigger) { Money.new(10, currency) }
      let(:less) { Money.new(1, other_currency) }
      before do
        Money.exchange_rates(other_currency, {currency => 1.1})
      end
      it 'returns true if converted amount is less then current amount' do
        expect(bigger > less).to be true
      end
      after do
        Money::EXCHANGE_TABLE.delete(other_currency)
      end
    end

    context 'when other argument is not Money' do
      it 'raises TypeError' do
        expect{Money.new(1, currency) > 1}.to raise_error(TypeError)
        expect{Money.new(1, currency) > Object.new}.to raise_error(TypeError)
      end
    end
  end

  describe '#<' do
    context 'with the same currencies' do
      let(:bigger) { Money.new(10, currency) }
      let(:less) { Money.new(1, currency) }

      it 'returns true when second amount is bigger then the first' do
        expect(less < bigger).to be true
      end
      it 'returns false when first amount is bigger then the second' do
        expect(bigger < less).to be false
      end
    end

    context 'with different currencies' do
      let(:bigger) { Money.new(10, currency) }
      let(:less) { Money.new(1, other_currency) }
      before do
        Money.exchange_rates(currency, {other_currency => 1.1})
      end
      it 'returns true if converted amount is bigger then current amount' do
        expect(less < bigger).to be true
      end
      after do
        Money::EXCHANGE_TABLE.delete(currency)
      end
    end

    context 'when other argument is not Money' do
      it 'raises TypeError' do
        expect{Money.new(1, currency) > 1}.to raise_error(TypeError)
        expect{Money.new(1, currency) > Object.new}.to raise_error(TypeError)
      end
    end
  end

  describe '#==' do
    context 'when currencies are equal' do
      it 'should return true if both amounts are equal' do
        expect(Money.new(1, currency)).to eq Money.new(1, currency)
      end
    end

    context 'when currencies are different' do
      before do
        Money.exchange_rates(currency, {other_currency => 1.1})
      end
      it 'returns true if converted amount is equal to current amount' do
        expect(Money.new(11, other_currency)).to eq(Money.new(10, currency))
      end
      after do
        Money::EXCHANGE_TABLE.delete(currency)
      end
    end

    it 'should return false if used against object that is not Money' do
      expect(Money.new(1, currency)).not_to eq Object.new
      expect(Money.new(1, currency)).not_to eq nil
    end
  end
end
