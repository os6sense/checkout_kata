require_relative '../lib/product.rb'
require 'spec_helper'

describe Product do
  describe '#initialize' do
    let(:code) { '001' }
    let(:description) { 'description' }
    let(:price) { 925 }

    subject { described_class.new(code, description, price) }

    it 'requires three parameters' do
      is_expected.to be_a described_class
    end

    it 'sets the code attribute to the value of the first parameter' do
      expect(subject.code).to eq code
    end

    it 'sets the description attribute to the value of the second parameter' do
      expect(subject.description).to eq description
    end

    context 'when the third paramter is an integer' do
      it 'creates an instance of Money for the price ' do
        expect(subject.price).to be_a Money
      end
    end
    context 'when the third paramter is not an integer' do
      let(:price) { 9.25 }
      it 'raises an ArgumentError' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
end

describe Products do
  describe '#add' do
    let(:product) { Product.new('004', 'Test', 1000) }
    it 'adds a product' do
      described_class.add(product)
      p = described_class.find_by_id('004')
      expect(described_class.find_by_id('004')).to eq product
    end
  end

  describe '#find_by_id' do
    context 'when provided a valid id' do
      let(:id) { '001' }
      it 'returns a Product' do
        expect(Products.find_by_id(id)).to be_a Product
      end
    end

    context 'when provided an invalid id' do
      it 'returns nil' do
        expect(Products.find_by_id('xy001')).to eq nil
      end
    end
  end
end
