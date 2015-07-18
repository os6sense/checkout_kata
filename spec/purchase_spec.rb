require_relative '../lib/purchases.rb'

describe Purchase do
  let(:product) { double('Product', price: 100) }
  let(:quantity) { 2 }

  subject { Purchase.new(product) }
  describe '#initialize' do
    context 'when a single parameter is supplied' do
      it 'sets #product to the value supplied' do
        expect(subject.product).to eq product
      end
      it 'sets #quantity to 0' do
        expect(subject.quantity).to eq 0
      end

      context 'when two parameters are supplied' do
        subject { Purchase.new(product, quantity) }

        it 'sets #quantity to the supplied value' do
          expect(subject.quantity).to eq quantity
        end
      end
    end
  end

  describe '#quanity' do
    let(:new_q) { 1001 }
    it 'can be changed' do
      subject.quantity = new_q
      expect(subject.quantity).to eq new_q
    end
  end

  describe '#price' do
    subject { Purchase.new(product, quantity) }
    it 'calculates the @product price multiplied by quantity' do
      expect(subject.price).to eq product.price * quantity

      subject.quantity = 3
      expect(subject.price).to eq product.price * 3
    end
  end
end
