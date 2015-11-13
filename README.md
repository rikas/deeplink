[![Build Status](https://travis-ci.org/rikas/deeplink.svg?branch=master)](https://travis-ci.org/rikas/deeplink) [![Build Status](https://travis-ci.org/rikas/deeplink.svg?branch=master)](https://travis-ci.org/rikas/deeplink)

# Deeplink

Handle deep links in an easy way.

This gem needs ruby version >= 2.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'deeplink'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install deeplink

## Usage

### Parsing a deep link

Just call `Deeplink.parse` with a deep link String and then you can read the scheme and path.

```ruby
deeplink = Deeplink.parse('foursquare://checkins/12932')

deeplink.scheme # => "foursquare"
deeplink.path   # => "/checkins/12932"
deeplink.to_s   # => "foursquare://checkins/12932"
```

### Query string

To get the query parameters of a link use `query` method.

```ruby
deeplink = Deeplink.parse('foursquare://checkins/209823?test=true')

deeplink.query # => { :test => "true" }
```

#### Adding a query parameter

You can add one or more query parameters sending a Hash to `add_query`.

```ruby
deeplink = Deeplink.parse('foursquare://checkins/20982')

deeplink.add_query(foo: 'bar') # => { :foo => "bar" }
deeplink.to_s                  # => "foursquare://checkins/20982?foo=bar"

deeplink = Deeplink.parse('foursquare://checkins/20982')

deeplink.add_query(foo: 'bar', biz: 'baz') # => { :foo => "bar", :biz => "baz" }
deeplink.to_s                              # => "foursquare://checkins/20982?foo=bar&biz=baz"
```

#### Removing a query parameter

To remove query parameters call `remove_query` with the key (or list of keys) that you want to
remove. The method will return the value of the deleted key(s).

```ruby
deeplink = Deeplink.parse('foursquare://checkins/20982?foo=bar')

deeplink.remove_query(:foo) # => "bar"
deeplink.to_s               # => "foursquare://checkins/20982"
```

```ruby
deeplink = Deeplink.parse('foursquare://checkins/20982?foo=bar&fu=baz')

deeplink.remove_query(:foo, :fu) # => ["bar", "baz"]
deeplink.to_s                    # => "foursquare://checkins/20982"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rikas/deeplink.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
