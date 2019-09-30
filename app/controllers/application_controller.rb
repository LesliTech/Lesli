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

    private

    def get_browser_locale
        accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
        return unless accept_language
        accept_language.scan(/^[a-z]{2}/).first
    end

end
