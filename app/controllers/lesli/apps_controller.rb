module Lesli
    class AppsController < ApplicationLesliController

        def show
            # renders the engine selector view
        end

        def language

            # check if param locale was sent by the user
            unless params[:locale].blank?

                locale = params[:locale].to_sym

                # check if locale requested is valid
                if I18n.available_locales.include?(locale)

                    # save requested locale in session
                    # this will be used in application_controller#switch_locale
                    session[:locale] = locale

                end

            end

            I18n.locale = locale

            redirect_back(fallback_location: request.referer)
        end
    end
end
