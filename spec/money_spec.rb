require "spec_helper"

describe Mymoney::Money do
  let(:amount) { 10 }
  let(:currency) { 'EUR' }

  subject { Mymoney::Money.new(amount, currency)}

  it { is_expected.to respond_to(:amount) }
  it { is_expected.to respond_to(:currency) }
  it { is_expected.to respond_to(:inspect) }

  describe '#inspect' do
    it 'should print out amount with currency' do
      expect(subject.inspect).to eq("#{amount} #{currency}")
    end
  end

  describe '#amount_full' do
    it 'returns BigDecimal representation of amount' do
      expect(subject.amount_full).to eq(BigDecimal.new(amount, Mymoney::Money::DEFAULT_PRECISION))
    end
  end
end
