# frozen_string_literal: true

module Servicer
  # This is base class for subclassing your services.
  # Example:
  #   class MyClass < ::Servicer::Base
  #     layer :require_user
  #
  #     def call(current_user, params)
  #       true
  #     end
  #   end
  #
  #   MyClass.call(current_user, params)
  class Base
    class AuthorizationError < ::Servicer::AuthorizationError; end
    class ParamsError < ::Servicer::ParamsError; end

    attr_reader :current_user, :params

    class << self
      def layers
        @layers ||= []
      end

      # Apply layer. Layer class can be any class based on ::Servicer::Layers::Base or symbolized name of layer.
      def layer(layer_class, options = {}, &block)
        layer_class = ::Servicer::Layers.const_get(layer_class.to_s.camelcase) if layer_class.is_a?(Symbol)
        layers << layer_class.new(options, &block)
      end

      # Main call. Will create instance and run `call` on it. In most cases instance method should be overwritten.
      def call(current_user, params)
        current_user, params = layers.inject([current_user, params]) { |arr, layer| layer.call(arr[0], arr[1]) }
        new(current_user, params).call
      end
    end

    # Main call. Overwrite this.
    def call
      raise NotImplementedError
    end

    private

    def initialize(current_user, params)
      @current_user = current_user
      @params = params
    end
  end
end
