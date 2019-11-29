module RoutesLock
    def self.extended(router)
        router.instance_exec do
            resources :locks
            namespace :lock do
                resources :roles
                resources :role_overrides
                resources :role_privileges
            end
        end
    end
end
