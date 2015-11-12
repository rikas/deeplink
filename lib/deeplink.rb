require 'uri'
require 'deeplink/link'
require 'deeplink/version'

module Deeplink
  def self.parse(link)
    Link.new(link)
  end
end
