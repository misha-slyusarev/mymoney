require "spec_helper"

describe Mymoney::Exchange do
  let(:currency) { 'EUR' }
  let(:rates) { {'USD' => 1.1, 'Bitcoin' => 0.98} }
  let(:amount) { 10 }
  let(:converted_amount) { 11 }

  describe '.exchange_rates' do
    let(:new_rates) { {'CAD' => 1.2} }
    subject { Mymoney::Money }

    context 'when currency is not in the table' do
      before do
        subject.exchange_rates(currency, rates)
      end

      it 'should add new currency' do
        expect(subject::EXCHANGE_TABLE).to eq({currency => rates})
      end
    end

    context 'when currency is already in the table' do
      before do
        subject.exchange_rates(currency, rates)
        subject.exchange_rates(currency, new_rates)
      end

      it 'should merge existing rates with new one' do
        expect(subject::EXCHANGE_TABLE).to eq({currency => rates.merge(new_rates)})
      end
    end

    after do
      subject::EXCHANGE_TABLE.delete(currency)
    end
  end

  describe '#convert_to' do
    subject { Mymoney::Money.new(amount, currency) }

    context 'when current currency is not in the table' do
      it 'should raise Mymoney::NoExchangeRateError' do
        expect{subject.convert_to('CAD')}.to raise_error(Mymoney::NoExchangeRateError)
      end
    end

    context 'when currency to convert to has no rate for current currency' do
      before do
        Mymoney::Money.exchange_rates(currency, rates)
      end
      it 'should raise Mymoney::NoExchangeRateError' do
        expect{subject.convert_to('CAD')}.to raise_error(Mymoney::NoExchangeRateError)
      end
      after do
        Mymoney::Money::EXCHANGE_TABLE.delete(currency)
      end
    end

    context 'when exchange table is filled out properly' do
      before do
        Mymoney::Money.exchange_rates(currency, rates)
      end

      it 'should return converted Money object' do
        converted = subject.convert_to('USD')

        expect(converted).to be_a(Mymoney::Money)
        expect(converted.currency).to eq('USD')
        expect(converted.amount).to eq(converted_amount)
      end
    end
  end
end
