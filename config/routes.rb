Rails.application.routes.draw do
    
    devise_scope :user do
        get "user/register", to: "devise/registrations#new"
        get "user/logout", to: "devise/sessions#destroy"
        get "user/login", to: "devise/sessions#new"
    end
    devise_for :users
    
    root to: 'website/pages#landing'

    # Load routes by module name
    extend Websites

end
