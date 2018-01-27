# frozen_string_literal: true

module Servicer
  module Layers
    # Layer validating provided params and raising ::Servicer::ParamsError if validation was unsuccessful.
    # It uses `dry-validation` gem schema to build validation options. Please note that you need to add
    # `dry-validations` to your Gemfile, as Servicer is not requiring it automatically.
    # Please consult http://dry-rb.org/gems/dry-validation/ for details of how to build it.
    # Example:
    #   layer :validate_params do
    #     optional(:limit).maybe(:int?, gt?: 0, lt?: 1_000)
    #     optional(:offset).maybe(:int?)
    #   end
    class ValidateParams < ::Servicer::Layers::Base
      def initialize(options, &block)
        super
        @schema = ::Dry::Validation.Schema do
          configure do
            config.input_processor = :sanitizer
          end

          instance_eval(&block)
        end
      end

      def call(current_user, params)
        validation = @schema.call(params)
        raise ParamsError, validation.errors unless validation.success?

        [current_user, validation.output]
      end
    end
  end
end
