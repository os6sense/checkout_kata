require_relative '../lib/promotional_rules.rb'

describe PromotionalRule do
  let(:probe) { -> {} }

  describe '#initialize' do
    let(:trigger) { -> {} }

    context 'when no block is provided' do
      it 'raises an ArgumentError' do
        expect { described_class.new(trigger) }.to raise_error ArgumentError
      end
    end

    context 'when a block is provided' do
      subject { described_class.new(trigger, &probe) }
      it 'creates an instance of the class' do
        expect(subject).to be_a described_class
      end
      it 'sets the discount attibute to the supplied block' do
        expect(subject.discount).to eq probe
      end
    end
  end

  describe '#applies_to?' do
    let(:trigger) { -> (p, _b) { p.code == '001' ? true : false } }
    subject { described_class.new(trigger, &probe) }

    context 'when the trigger rule applies to the product' do
      let(:product) { instance_double('Product',  code: '001') }
      it 'returns the rule' do
        expect(subject.applies_to?(product, nil)).to eq true
      end
    end

    context 'when the trigger rule does not apply to the product' do
      let(:product) { instance_double('Product',  code: 'xx001') }
      it 'returns nil' do
        expect(subject.applies_to?(product, nil)).to eq false
      end
    end
  end
end
