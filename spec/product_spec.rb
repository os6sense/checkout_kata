require_relative '../lib/product.rb'

describe Product do
  describe '#initialize' do
    let(:code) { '001' }
    let(:description) { 'description' }
    let(:price) { 9.25 }

    subject { described_class.new(code, description, price) }

    it 'requires three parameters' do
      expect(subject).to be_a described_class
    end

    it 'sets the code attribute to the value of the first parameter' do
      expect(subject.code).to eq code
    end

    it 'sets the description attribute to the value of the second parameter' do
      expect(subject.description).to eq description
    end

    it 'sets the price attribute to the value of the second parameter' do
      expect(subject.price).to eq price
    end
  end
end
