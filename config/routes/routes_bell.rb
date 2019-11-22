module RoutesBell
    def self.extended(router)
        router.instance_exec do
            resources :bells
            namespace :bell do
                resources :emails
                resources :messages
                resources :notifications
            end
        end
    end
end
