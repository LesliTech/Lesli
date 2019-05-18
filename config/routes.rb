Rails.application.routes.draw do

    devise_for :users
    
    root to: 'website/pages#landing'

    # Load routes by module name
    extend Websites

end
