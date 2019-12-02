module RoutesAdmin
    def self.extended(router)
        router.instance_exec do
            scope "admin" do
                resources :users
                namespace :user do
                    resources :details
                end
            end
        end
    end
end
