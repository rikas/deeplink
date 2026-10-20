[![Gem Version](https://badge.fury.io/rb/deeplink.svg)](https://badge.fury.io/rb/deeplink)
[![CI](https://github.com/rikas/deeplink/actions/workflows/ci.yml/badge.svg)](https://github.com/rikas/deeplink/actions/workflows/ci.yml)

# Deeplink

Parse, inspect and build mobile deep links (`myapp://products/42?ref=email`) in an easy way.

Ruby's `URI` treats the first part after `://` as a host, so deep links like `myapp://products/42`
end up with `products` as the host. This gem reads them the way apps do: a scheme, a path, a query
and a fragment.

This gem needs Ruby >= 3.2.

## Installation

```sh
bundle add deeplink
```

Or install it yourself:

```sh
gem install deeplink
```

## Usage

### Parsing a deep link

Call `Deeplink.parse` with a deep link string to read its scheme and path.

```ruby
deeplink = Deeplink.parse('myshop://products/42')

deeplink.scheme # => "myshop"
deeplink.path   # => "/products/42"
deeplink.to_s   # => "myshop://products/42"
```

Links without a double slash are supported too:

```ruby
deeplink = Deeplink.parse('sms:+351910000000?body=hello')

deeplink.scheme # => "sms"
deeplink.path   # => "+351910000000"
deeplink.to_s   # => "sms:+351910000000?body=hello"
```

### Query string

Use `query` to read the query parameters, and `query?` to check whether there are any.

```ruby
deeplink = Deeplink.parse('myshop://products/42?ref=email')

deeplink.query  # => { ref: "email" }
deeplink.query? # => true
```

Values are stored decoded and only encoded again by `to_s`. Parameters without a value get a `nil`
value.

```ruby
deeplink = Deeplink.parse('myshop://search?q=running%20shoes&in_stock')

deeplink.query # => { q: "running shoes", in_stock: nil }
deeplink.to_s  # => "myshop://search?q=running+shoes&in_stock"
```

#### Adding query parameters

Send a Hash with one or more parameters to `add_query`. Values are converted to strings.

```ruby
deeplink = Deeplink.parse('myshop://cart')

deeplink.add_query(coupon: 'SUMMER 10', items: 3) # => { coupon: "SUMMER 10", items: "3" }
deeplink.to_s                                     # => "myshop://cart?coupon=SUMMER+10&items=3"
```

#### Removing query parameters

Call `remove_query` with the key (or list of keys) to remove. It returns the value of the deleted
key(s).

```ruby
deeplink = Deeplink.parse('myshop://products/42?ref=email&utm_source=newsletter')

deeplink.remove_query(:utm_source) # => "newsletter"
deeplink.to_s                      # => "myshop://products/42?ref=email"

deeplink.remove_query(:ref, :missing) # => ["email", nil]
deeplink.to_s                         # => "myshop://products/42"
```

### Fragment

The fragment is available through `fragment`, and is kept as given (percent-encoded).

```ruby
deeplink = Deeplink.parse('myshop://products/42#reviews')

deeplink.fragment # => "reviews"
deeplink.to_s     # => "myshop://products/42#reviews"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake`
to run the tests and RuboCop. You can also run `bin/console` for an interactive prompt that will
allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb` and `CHANGELOG.md`, and then run
`bundle exec rake release`, which will create a git tag for the version, push git commits and tags,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rikas/deeplink.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
