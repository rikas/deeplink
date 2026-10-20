# frozen_string_literal: true

require 'uri'

# Ruby 4.0 removed the CGI library; CGI.escape and CGI.unescape now live in cgi/escape.
if RUBY_VERSION >= '4'
  require 'cgi/escape'
else
  require 'cgi/util'
end

module Deeplink
  class Link
    # The fragment is kept as given, so it should already be percent-encoded.
    attr_accessor :scheme, :path, :fragment

    # Query values are stored decoded and only encoded by #to_s. To add and remove items to the
    # query string use #add_query and #remove_query.
    attr_reader :query

    def initialize(uri)
      return unless uri

      uri = parse(uri)

      self.scheme = uri.scheme
      self.fragment = uri.fragment

      # Links without "//" (e.g. "deep:foo?a=1") are opaque, and URI leaves the query in there.
      self.path, query_string = uri.opaque ? uri.opaque.split('?', 2) : [uri.path, uri.query]

      @query = parse_query(query_string) if query_string
    end

    # Add query parameters to the link. You can add one or more parameters since this method
    # receives a hash.
    #
    # === Example
    #
    #   deeplink = Deeplink.parse("link://directions")
    #
    #   deeplink.add_query(lat: 38.7179233, lon: -9.150129)
    #
    #   deeplink.to_s # => "link://directions?lat=38.7179233&lon=-9.150129"
    #
    # Values are converted to strings. A nil value adds a parameter without a value ("?flag").
    def add_query(hash)
      @query ||= {}

      @query.merge!(sanitize(hash))
    end

    # Removes query parameters by its keys. You can remove one or more parameters, sending a list of
    # keys.
    #
    # === Example
    #
    #   deeplink = Deeplink.parse("link://directions?lat=38.7179233&lon=-9.150129&test=true")
    #
    #   deeplink.remove_query(:test) # => "true"
    #
    #   deeplink.remove_query(:lat, :lon) # => [38.7179233, -9.150129]
    def remove_query(*keys)
      return unless query

      values = keys.map { |key| query.delete(key.to_sym) }

      keys.size > 1 ? values : values.first
    end

    # Returns true if the link has a query string or false otherwise
    #
    # === Example
    #
    #   deeplink = Deeplink.parse("link://directions")
    #
    #   deeplink.query?             # => false
    #
    #   deeplink.add_query(foo: "bar")  # => { :foo => "bar" }
    #
    #   deeplink.query?             # => true
    def query?
      return false unless query

      !query.empty?
    end

    alias has_query? query?

    # Returns the link as a String
    def to_s
      return '' unless scheme && path

      uri = @double_slash ? "#{scheme}:/#{path}" : "#{scheme}:#{path}"
      uri += "?#{query_string}" if query?
      uri += "##{fragment}" if fragment

      uri
    end

    private

    def parse(original_uri)
      @double_slash = original_uri.match?(%r{\A[^:/?#]+://})

      # Because URI is dumb and thinks that every uri needs to have a host. Adding an extra slash
      # we are basically tricking URI to think that host is nil (and avoid errors).
      uri = @double_slash ? original_uri.sub('://', ':///') : original_uri

      URI.parse(uri)
    end

    def sanitize(hash)
      hash.to_h { |key, value| [key.to_sym, value&.to_s] }
    end

    def parse_query(query_str)
      query_str.split('&').each_with_object({}) do |pair, params|
        key, value = pair.split('=', 2)
        next if key.nil? || key.empty?

        params[CGI.unescape(key).to_sym] = value && CGI.unescape(value)
      end
    end

    def query_string
      query.map do |key, value|
        key = CGI.escape(key.to_s)

        value.nil? ? key : "#{key}=#{CGI.escape(value)}"
      end.join('&')
    end
  end
end
