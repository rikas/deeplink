# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'deeplink'

# rubocop:disable Style/MixinUsage
include Deeplink
# rubocop:enable Style/MixinUsage
