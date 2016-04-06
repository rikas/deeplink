require 'uri'
require 'cgi'

module Deeplink
  class Link
    attr_accessor :scheme, :path

    # To add and remove items to the query string use #add_query and #remove_query
    attr_reader :query

    def initialize(uri)
      return unless uri

      uri = parse(uri)

      self.scheme = uri.scheme
      self.path = uri.path

      @query = sanitize(parse_query(uri.query)) if uri.query
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

      if keys.size > 1
        keys.map { |key| query.delete(key.to_sym) }
      else
        query.delete(keys.first.to_sym)
      end
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

    alias_method :has_query?, :query?

    # Returns the link as a String
    def to_s
      return '' unless scheme && path

      uri = "#{scheme}:/#{path}"

      if query?
        query_string = query.map { |key, value| "#{key}=#{value}" }.join('&')
        uri << "?#{query_string}"
      end

      uri
    end

    private

    def parse(original_uri)
      # Because URI is dumb and thinks that every uri needs to have a host. Adding an extra slash
      # we are basically tricking URI to think that host is nil (and avoid errors).
      uri = original_uri.sub(%r{://}, ':///')

      URI.parse(uri)
    end

    def sanitize(hash)
      sanitized = {}

      hash.each_key do |key|
        value = hash[key].is_a?(String) ? CGI.escape(hash[key]) : hash[key].to_s

        sanitized[key.to_sym] = value
      end

      sanitized
    end

    def parse_query(query_str)
      return unless query_str

     param_name_value_pairs = query_str.scan(/([^&=]+)=([^&#{}]*)/)
     array_to_h(param_name_value_pairs)
    end

    #~~~~~~~~~~~~~~
    private 
    
    def array_to_h(array)
      if array.respond_to?(:to_h)
        array.to_h
      else
        Hash[*array.flatten]
      end
    end
  end
end
