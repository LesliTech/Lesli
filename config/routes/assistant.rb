module Assistant
    def self.extended(router)
        router.instance_exec do

            #resources :assistants
            get '/lesli', to: 'assistants#lesli_dashboard'

        end
    end
end
