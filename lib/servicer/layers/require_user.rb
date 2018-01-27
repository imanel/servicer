# frozen_string_literal: true

module Servicer
  module Layers
    # Layer verifying if current user exists, and raises ::Servicer::AAuthorizationError otherwise.
    # Example:
    #   layer :require_user
    class RequireUser < ::Servicer::Layers::Base
      def call(current_user, params)
        raise AuthorizationError if current_user.nil?
        [current_user, params]
      end
    end
  end
end
