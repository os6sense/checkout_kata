require_relative '../lib/checkout.rb'
require_relative 'spec_helper'

describe Checkout do
  subject { described_class.new(rules) }

  let(:rules)  { double('PromotionalRules') }

  describe '#initialize' do
    it { is_expected.to be_a described_class }

    it 'assigns the passed parameter to #rules' do
      expect(subject.rules).to eq rules
    end

    it 'initializes #purchases to an instance of Purchases' do
      expect(subject.purchases).to be_a Purchases
    end
  end

  describe '#scan' do
    let(:item) { instance_double('Product') }
    before { subject.scan(item) }

    it 'adds a product to the purchases' do
      expect(subject.purchases).to include(item)
    end
  end

  describe '#total' do
    let(:promotional_rules) { default_promotions }

    subject do
      co = Checkout.new(promotional_rules)
      items.each { |item| co.scan(Products.find_by_id(item)) }
      co.total
    end

    context 'when no items have been scanned' do
      let(:items) { %w() }
      it { is_expected.to eq Money.new(0) }
    end

    context 'when it has a basket containing products 001, 002, 003' do
      let(:items) { %w(001 002 003) }
      it { is_expected.to eq Money.new(6678) }
    end

    context 'when it has a basket containing products 001, 003, 001' do
      let(:items) { %w(001 003 001) }
      it { is_expected.to eq Money.new(3695) }
    end

    context 'when it has a basket containing products 001, 002, 001, 003' do
      let(:items) { %w(001 002 001 003) }
      it { is_expected.to eq Money.new(7376) }
    end
  end
end
