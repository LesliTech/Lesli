class ApplicationController < ActionController::Base

    # create method to switch locale
    #around_action :switch_locale

    def switch_locale(&action)

        # using configured default language first
        locale = I18n.default_locale

        # check configured language of user browser
        browser_locale = get_browser_locale
        if browser_locale
            locale = browser_locale
        end

        # check if there is a locale in the current session
        if session[:locale]
            locale = session[:locale]
        end

        # locale requested by the user
        if params[:locale]
            locale = params[:locale]
            session[:locale] = locale
        end

        # I should check locale in the database here

        I18n.with_locale(locale, &action)

    end

    # JSON successful response
    def responseWithSuccessful(data = nil)
        response_body = { successful: true }
        response_body[:data] = data unless data.blank?
        render status: 200, json: response_body.to_json
    end

    # JSON failure response
    def responseWithError(message = "", details = nil)
        render status: 200, json: {
            successful: false,
            error: {
                message: message,
                details: details
            }
        }.to_json
    end

    # JSON not found response
    def responseWithNotFound
        render status: 404, json: {
            successful: false,
            error: {
                message: 'Not found',
                details: []
            }
        }.to_json
    end

    private

    def get_browser_locale
        accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
        return unless accept_language
        accept_language.scan(/^[a-z]{2}/).first
    end

end
