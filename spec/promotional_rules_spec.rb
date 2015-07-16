require_relative '../lib/promotional_rules.rb'

describe PromotionalRules do
  let(:product) { double("Product") }

  describe '#initialize' do
    context 'when a no parameter is provided' do
      it 'raises an ArgumentErro' do
        expect { described_class.new }.to raise_error ArgumentError
      end
    end
    context 'when a parameter is provided' do
      context 'when no block is provided' do
        it 'raises an ArgumentError' do
          expect { described_class.new(product) }.to raise_error ArgumentError
        end
      end

      context 'when a block is provided' do
        let(:probe) { lambda{} }
        subject { described_class.new(product, &probe) }

        it 'sets the product attribute to the parameter' do
          expect(subject).to be_a described_class
        end
        it 'sets the product attibute to product' do
          expect(subject.product).to eq product
        end
        it 'sets the block attibute to the supplied block' do
          expect(subject.block).to eq probe
        end

      end
    end
  end

  describe '#apply' do
    let(:probe) { lambda{} }

    subject { described_class.new(product, &probe) }

    context 'when passed a basket' do
      it 'calls the stored block' do
          #expect(probe).to receive :call
          #subject.
      end
    end
  end
end
