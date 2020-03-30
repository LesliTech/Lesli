class ApplicationController < ActionController::Base

    # create method to switch locale
    around_action :switch_locale
 
    def switch_locale(&action)

        # get saved language in session or the default in config
        # the session param is setted in settings controller through "get :language, to: 'settings#language'"
        locale = session[:locale] || I18n.default_locale

        # I should check locale in the database here
        # the options are
            # - I18n.available_locales
            # - automatic according to os or browser

        # set the new locale
        I18n.with_locale(locale, &action)

    end

    # JSON successful response
    def responseWithSuccessful(data = nil)
        response_body = { successful: true }
        response_body[:data] = data
        render status: 200, json: response_body.to_json
    end

    # JSON failure response
    def responseWithError(message = "", details = [])
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
