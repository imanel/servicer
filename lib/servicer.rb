# frozen_string_literal: true

# Simple Service Object builder.
# See ::Servicer::Base for how to use it.
module Servicer
  class Error < StandardError; end
  class AuthorizationError < Error; end
  class ParamsError < Error; end

  require_relative 'servicer/base'
  require_relative 'servicer/layers'
  require_relative 'servicer/version'
end
