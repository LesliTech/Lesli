class ApplicationPublicController < ApplicationController
    include Interfaces::Application::Responder
    include Interfaces::Application::Requester
    include Interfaces::Application::Logger

    #include Application::Requester
    #include Application::Responder
    #include Application::Logger

    before_action :set_locale
    before_action :set_helpers_for_request
end
