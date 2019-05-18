module Websites
    def self.extended(router)
      router.instance_exec do
        namespace :websites do
          resources :landings
        end
      end
    end
  end
  