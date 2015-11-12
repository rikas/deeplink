require 'uri'
require 'cgi'

module Deeplink
  class Link
    attr_accessor :scheme, :path, :query

    def initialize(uri)
      uri = parse(uri) unless uri.kind_of?(URI)

      self.scheme = uri.scheme
      self.path = uri.path
      self.query = sanitize(parse_query(uri.query)) if uri.query
    end

    def add_query(hash)
      self.query ||= {}

      query.merge!(sanitize(hash))
    end

    def remove_query(key)
      return unless query

      query.delete(key.to_sym)
    end

    def has_query?
      return false unless query

      !query.empty?
    end

    def to_s
      string = "#{scheme}:/#{path}"

      if has_query?
        query_string = query.map { |key, value| "#{key}=#{value}" }.join('&')
        string << "?#{query_string}"
      end

      string
    end

    private

    def parse(string)
      # Because URI is dumb and thinks that every uri needs to have a host. Adding an extra slash
      # we are basically tricking URI to think that host is nil (and avoid errors).
      uri = string.sub(%r{://}, ':///')

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

      query_str.scan(/([[:alnum:]]+)=([[:alnum:]]+)/).to_h
    end
  end
end
