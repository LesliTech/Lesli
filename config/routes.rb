Rails.application.routes.draw do

    #root to: 'landing#index'
    root to: 'website/landings#index'

    # Load routes by module name
    extend Websites

end
