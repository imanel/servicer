# frozen_string_literal: true

module Servicer
  module Layers
    # Layer setting default params using deep_merge.
    # Example:
    #   layer :set_default_params, {
    #     limit: 10
    #     offset: 0
    #   }
    class SetDefaultParams < ::Servicer::Layers::Base
      def call(current_user, params)
        # TODO: Remove hidden dependency on ActiveSupport
        [current_user, @options.deep_merge(params)]
      end
    end
  end
end
