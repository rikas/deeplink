require 'spec_helper'

describe Link do
  it 'works with a string' do
    expect { described_class.new('test://lol') }.to_not raise_exception
  end

  it 'works with an URI instance' do
    expect { described_class.new(URI.parse('test://lol')) }.to_not raise_exception
  end

  context 'link with scheme only' do
    subject { described_class.new('deep://') }

    it 'parses the link correctly' do
      expect(subject.path).to eq('/')
      expect(subject.scheme).to eq('deep')
      expect(subject.query).to be_nil
    end

    describe '#has_query?' do
      it 'returns false' do
        expect(subject.has_query?).to be_falsy
      end
    end

    describe '#add_query' do
      it 'adds a parameter correctly' do
        subject.add_query(teste: 1)

        expect(subject.has_query?).to be_truthy
        expect(subject.query).to include(:teste)
      end
    end

    describe '#to_s' do
      it 'returns the correct string' do
        expect(subject.to_s).to eq('deep://')
      end
    end
  end

  context 'link with scheme and path' do
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

        expect(normal.has_query?).to be_truthy
        expect(trailing_slash.has_query?).to be_truthy

        expect(normal.query).to include(:foo, :fizz)
        expect(trailing_slash.query).to include(:bah)
      end
    end

    describe '#has_query?' do
      it 'returns false' do
        expect(normal.has_query?).to be_falsy
        expect(trailing_slash.has_query?).to be_falsy
      end
    end

    describe '#to_s' do
      it 'returns the correct string' do
        expect(normal.to_s).to eq('link1://path/to/link')
        expect(trailing_slash.to_s).to eq('link2://path/link/')
      end
    end
  end

  context 'complete link' do
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

    describe '#has_query?' do
      it 'returns trye' do
        expect(one.has_query?).to be_truthy
        expect(multiple.has_query?).to be_truthy
      end
    end

    describe '#add_query' do
      it 'adds a parameter correctly' do
        one.add_query(test: 1)
        multiple.add_query(bar: 'scumm')

        expect(one.has_query?).to be_truthy
        expect(one.query).to eq(query: 'string', test: '1')

        expect(multiple.has_query?).to be_truthy
        expect(multiple.query).to eq(query: 'string', two: '2', bar: 'scumm')
      end

      it 'adds_multiple parameters correctly' do
        one.add_query(one: 1, two: 2, three: 3)

        expect(one.query).to eq(query: 'string', one: '1', two: '2', three: '3')
      end
    end

    describe '#remove_query' do
      it 'removes a parameter correctly' do
        one.remove_query(:query)
        multiple.remove_query(:query)

        expect(one.query).to be_empty
        expect(one.has_query?).to be_falsy
        expect(multiple.query).to eq(two: '2')
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
