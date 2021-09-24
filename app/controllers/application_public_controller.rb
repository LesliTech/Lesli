class ApplicationPublicController < ApplicationController
    include Application::Requester
    include Application::Responder

    before_action :set_locale
end
