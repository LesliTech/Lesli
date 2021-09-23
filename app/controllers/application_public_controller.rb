class ApplicationPublicController < ApplicationController
    include Application::Requester

    before_action :set_locale
end
