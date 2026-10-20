# frozen_string_literal: true

RSpec.describe Deeplink::Link do
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

  it 'does not double encode already encoded query values' do
    deeplink = described_class.new('deep://search?q=hello%20world')

    expect(deeplink.to_s).to eq('deep://search?q=hello+world')
  end

  it 'returns nil when removing a query without keys' do
    deeplink = described_class.new('deep://search?q=1')

    expect(deeplink.remove_query).to be_nil
  end

  it 'stores query values decoded and encodes them in #to_s' do
    deeplink = described_class.new('deep://search?q=a%20b&tag=c+d')
    deeplink.add_query(name: 'e&f')

    aggregate_failures do
      expect(deeplink.query).to eq(q: 'a b', tag: 'c d', name: 'e&f')
      expect(deeplink.to_s).to eq('deep://search?q=a+b&tag=c+d&name=e%26f')
    end
  end

  it 'encodes query values that are not strings' do
    deeplink = described_class.new('deep://search')
    deeplink.add_query(q: :'a b', page: 2)

    aggregate_failures do
      expect(deeplink.query).to eq(q: 'a b', page: '2')
      expect(deeplink.to_s).to eq('deep://search?q=a+b&page=2')
    end
  end

  it 'keeps query parameters without a value' do
    deeplink = described_class.new('deep://search?flag&empty=&q=1')
    deeplink.add_query(other: nil)

    aggregate_failures do
      expect(deeplink.query).to eq(flag: nil, empty: '', q: '1', other: nil)
      expect(deeplink.to_s).to eq('deep://search?flag&empty=&q=1&other')
    end
  end

  it 'keeps the fragment' do
    deeplink = described_class.new('deep://page?a=1#section%201')

    aggregate_failures do
      expect(deeplink.fragment).to eq('section%201')
      expect(deeplink.query).to eq(a: '1')
      expect(deeplink.to_s).to eq('deep://page?a=1#section%201')
    end
  end

  it 'parses links without a double slash' do
    opaque = described_class.new('deep:foo?a=1#f')
    absolute = described_class.new('deep:/foo')

    aggregate_failures do
      expect(opaque.scheme).to eq('deep')
      expect(opaque.path).to eq('foo')
      expect(opaque.query).to eq(a: '1')
      expect(opaque.fragment).to eq('f')
      expect(opaque.to_s).to eq('deep:foo?a=1#f')

      expect(absolute.path).to eq('/foo')
      expect(absolute.to_s).to eq('deep:/foo')
    end
  end

  it 'returns an empty link if nil if given' do
    deeplink = described_class.new(nil)

    aggregate_failures do
      expect(deeplink.query).to be_nil
      expect(deeplink.path).to be_nil
      expect(deeplink.query?).to be_falsy
      expect(deeplink.to_s).to eq('')
    end
  end

  context 'when the link has scheme only' do
    let(:link) { described_class.new('deep://') }

    it 'parses the link correctly' do
      aggregate_failures do
        expect(link.path).to eq('/')
        expect(link.scheme).to eq('deep')
        expect(link.query).to be_nil
      end
    end

    describe '#query?' do
      it 'returns false' do
        expect(link.query?).to be_falsy
      end
    end

    describe '#add_query' do
      it 'adds a parameter correctly' do
        link.add_query(teste: 1)

        aggregate_failures do
          expect(link.query?).to be_truthy
          expect(link.query).to include(:teste)
        end
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
      aggregate_failures do
        expect(normal.path).to eq('/path/to/link')
        expect(normal.scheme).to eq('link1')
        expect(normal.query).to be_nil

        expect(trailing_slash.path).to eq('/path/link/')
        expect(trailing_slash.scheme).to eq('link2')
        expect(trailing_slash.query).to be_nil
      end
    end

    describe '#add_query' do
      it 'adds a parameter correctly' do
        normal.add_query(foo: 'bar', fizz: 'baz')
        trailing_slash.add_query(bah: 'meh')

        aggregate_failures do
          expect(normal.query?).to be_truthy
          expect(trailing_slash.query?).to be_truthy

          expect(normal.query).to include(:foo, :fizz)
          expect(trailing_slash.query).to include(:bah)
        end
      end
    end

    describe '#query?' do
      it 'returns false' do
        aggregate_failures do
          expect(normal.query?).to be_falsy
          expect(trailing_slash.query?).to be_falsy
        end
      end
    end

    describe '#to_s' do
      it 'returns the correct string' do
        aggregate_failures do
          expect(normal.to_s).to eq('link1://path/to/link')
          expect(trailing_slash.to_s).to eq('link2://path/link/')
        end
      end
    end
  end

  context 'when the link is complete' do
    let(:one) { described_class.new('complete://link/for/?query=string') }
    let(:multiple) { described_class.new('multiple://link/for?query=string&two=2') }

    it 'parses the link correctly' do
      aggregate_failures do
        expect(one.path).to eq('/link/for/')
        expect(one.scheme).to eq('complete')
        expect(one.query).to eq(query: 'string')

        expect(multiple.path).to eq('/link/for')
        expect(multiple.scheme).to eq('multiple')
        expect(multiple.query).to eq(query: 'string', two: '2')
      end
    end

    describe '#query?' do
      it 'returns trye' do
        aggregate_failures do
          expect(one.query?).to be_truthy
          expect(multiple.query?).to be_truthy
        end
      end
    end

    describe '#add_query' do
      it 'adds a parameter correctly' do
        one.add_query(test: 1)
        multiple.add_query(bar: 'scumm')

        aggregate_failures do
          expect(one.query?).to be_truthy
          expect(one.query).to eq(query: 'string', test: '1')

          expect(multiple.query?).to be_truthy
          expect(multiple.query).to eq(query: 'string', two: '2', bar: 'scumm')
        end
      end

      it 'adds_multiple parameters correctly' do
        one.add_query(one: 1, two: 2, three: 3)

        expect(one.query).to eq(query: 'string', one: '1', two: '2', three: '3')
      end
    end

    describe '#remove_query' do
      it 'removes a parameter correctly' do
        aggregate_failures do
          expect(one.remove_query(:query)).to eq('string')
          expect(multiple.remove_query(:query)).to eq('string')

          expect(one.query).to be_empty
          expect(one.query?).to be_falsy
          expect(multiple.query).to eq(two: '2')
        end
      end

      it 'removes multiple parameters correctly' do
        aggregate_failures do
          expect(multiple.remove_query(:query, :two)).to eq(%w[string 2])
          expect(multiple.to_s).to eq('multiple://link/for')
        end
      end
    end

    describe '#to_s' do
      it 'returns the correct string' do
        aggregate_failures do
          expect(one.to_s).to eq('complete://link/for/?query=string')
          expect(multiple.to_s).to eq('multiple://link/for?query=string&two=2')
        end
      end

      it 'returns the correct string after adding a query param' do
        one.add_query(add: 'guybrush')

        expect(one.to_s).to eq('complete://link/for/?query=string&add=guybrush')
      end
    end
  end
end
