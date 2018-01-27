# frozen_string_literal: true

module Servicer
  # Module for Layers base.
  module Layers
    autoload :Base,             File.join(__dir__, 'layers', 'base')
    autoload :RequireUser,      File.join(__dir__, 'layers', 'require_user')
    autoload :SetDefaultParams, File.join(__dir__, 'layers', 'set_default_params')
    autoload :ValidateParams,   File.join(__dir__, 'layers', 'validate_params')
  end
end
