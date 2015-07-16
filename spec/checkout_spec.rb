require_relative '../lib/checkout.rb'
require_relative '../lib/product.rb'
require_relative '../lib/promotional_rules.rb'

describe Checkout do
  subject { described_class.new(rules) }

  let(:rules)  { double("PromotionalRules") }
  let(:item)  { instance_double("Product") }

  describe '#initialize' do
    it 'accepts a single parameter' do
      expect(subject).to be_a described_class
    end

    it 'assigns the passed parameter to the rules attribute' do
      expect(subject.rules).to eq rules
    end
  end

  describe '#scan' do
    it 'adds an item to the basket' do
      subject.scan(item)
      expect(subject.basket).to include(item)
    end
  end

  describe '#total' do
    #it "returns the total amount of items in the basket" do
    #end
  end
end
