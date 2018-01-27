# frozen_string_literal: true

module Servicer
  module Layers
    # Base class for creating Layers.
    class Base
      def call(current_user, params)
        [current_user, params]
      end

      private

      def initialize(options, &block)
        @options = options
        @block = block
      end
    end
  end
end
