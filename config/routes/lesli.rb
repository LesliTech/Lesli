module Lesli
    def self.extended(router)
        router.instance_exec do
            namespace :lesli do

            end
        end
    end
end
