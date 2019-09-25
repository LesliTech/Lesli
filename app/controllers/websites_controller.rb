class WebsitesController < PublicApplicationController
    layout 'application_public'

    def landing
    end

    

    def switch_locale2
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        p params[:locale]
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        p '*     *     *     *     *     *     *     *     *     *     *     *     *     *     *     *'
        session[:locale] = params[:locale] # if I18n.available_locales.include?(params[:locale].to_sym)
        redirect_back fallback_location: root_path
    end
    
end
