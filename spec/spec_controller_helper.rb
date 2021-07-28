require 'rails_helper'
require 'spec_helper'
require 'faker'
require 'support/helpers/controller_helpers'
require 'support/shared_contexts/controller_context_for_user_authentication'

RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, type: :controller
    config.include ControllerHelpers    
end
