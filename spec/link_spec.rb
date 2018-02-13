# frozen_string_literal: true

require 'spec_helper'

describe Link do
  it 'reads query keys with strange characters' do
    link = 'deep://directions?_id=1'

    deeplink = described_class.new(link)

    expect(deeplink.query).to eq(_id: '1')
  end

  it 'reads query values with strange characters' do
    link = 'deep://directions?id=_-1P'

    deeplink = described_class.new(link)

    expect(deeplink.query).to eq(id: '_-1P')
  end

  it 'returns an empty link if nil if given' do
    deeplink = described_class.new(nil)

    expect(deeplink.query).to be_nil
    expect(deeplink.path).to be_nil
    expect(deeplink.query?).to be_falsy
    expect(deeplink.to_s).to eq('')
  end

  context 'when the link has scheme only' do
    let(:link) { described_class.new('deep://') }

    it 'parses the link correctly' do
      expect(link.path).to eq('/')
      expect(link.scheme).to eq('deep')
      expect(link.query).to be_nil
    end

    describe '#query?' do
      it 'returns false' do
        expect(link.query?).to be_falsy
      end
    end

    describe '#add_query' do
      it 'adds a parameter correctly' do
        link.add_query(teste: 1)

        expect(link.query?).to be_truthy
        expect(link.query).to include(:teste)
      end
    end

    describe '#to_s' do
      it 'returns the correct string' do
        expect(link.to_s).to eq('deep://')
      end
    end
  end

  context 'when the link has scheme and path' do
    let(:normal) { described_class.new('link1://path/to/link') }
    let(:trailing_slash) { described_class.new('link2://path/link/') }

    it 'parses the link correctly' do
      expect(normal.path).to eq('/path/to/link')
      expect(normal.scheme).to eq('link1')
      expect(normal.query).to be_nil

      expect(trailing_slash.path).to eq('/path/link/')
      expect(trailing_slash.scheme).to eq('link2')
      expect(trailing_slash.query).to be_nil
    end

    describe '#add_query' do
      it 'adds a parameter correctly' do
        normal.add_query(foo: 'bar', fizz: 'baz')
        trailing_slash.add_query(bah: 'meh')

        expect(normal.query?).to be_truthy
        expect(trailing_slash.query?).to be_truthy

        expect(normal.query).to include(:foo, :fizz)
        expect(trailing_slash.query).to include(:bah)
      end
    end

    describe '#query?' do
      it 'returns false' do
        expect(normal.query?).to be_falsy
        expect(trailing_slash.query?).to be_falsy
      end
    end

    describe '#to_s' do
      it 'returns the correct string' do
        expect(normal.to_s).to eq('link1://path/to/link')
        expect(trailing_slash.to_s).to eq('link2://path/link/')
      end
    end
  end

  context 'when the link is complete' do
    let(:one) { described_class.new('complete://link/for/?query=string') }
    let(:multiple) { described_class.new('multiple://link/for?query=string&two=2') }

    it 'parses the link correctly' do
      expect(one.path).to eq('/link/for/')
      expect(one.scheme).to eq('complete')
      expect(one.query).to eq(query: 'string')

      expect(multiple.path).to eq('/link/for')
      expect(multiple.scheme).to eq('multiple')
      expect(multiple.query).to eq(query: 'string', two: '2')
    end

    describe '#query?' do
      it 'returns trye' do
        expect(one.query?).to be_truthy
        expect(multiple.query?).to be_truthy
      end
    end

    describe '#add_query' do
      it 'adds a parameter correctly' do
        one.add_query(test: 1)
        multiple.add_query(bar: 'scumm')

        expect(one.query?).to be_truthy
        expect(one.query).to eq(query: 'string', test: '1')

        expect(multiple.query?).to be_truthy
        expect(multiple.query).to eq(query: 'string', two: '2', bar: 'scumm')
      end

      it 'adds_multiple parameters correctly' do
        one.add_query(one: 1, two: 2, three: 3)

        expect(one.query).to eq(query: 'string', one: '1', two: '2', three: '3')
      end
    end

    describe '#remove_query' do
      it 'removes a parameter correctly' do
        expect(one.remove_query(:query)).to eq('string')
        expect(multiple.remove_query(:query)).to eq('string')

        expect(one.query).to be_empty
        expect(one.query?).to be_falsy
        expect(multiple.query).to eq(two: '2')
      end

      it 'removes multiple parameters correctly' do
        expect(multiple.remove_query(:query, :two)).to eq(%w[string 2])

        expect(multiple.to_s).to eq('multiple://link/for')
      end
    end

    describe '#to_s' do
      it 'returns the correct string' do
        expect(one.to_s).to eq('complete://link/for/?query=string')
        expect(multiple.to_s).to eq('multiple://link/for?query=string&two=2')
      end

      it 'returns the correct string after adding a query param' do
        one.add_query(add: 'guybrush')

        expect(one.to_s).to eq('complete://link/for/?query=string&add=guybrush')
      end
    end
  end
end
