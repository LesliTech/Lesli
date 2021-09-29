class ApplicationPublicController < ApplicationController
    include Application::Requester
    include Application::Responder
    include Application::Logger

    before_action :set_locale
end
