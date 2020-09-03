module LC

    module System

        class Routes

            def self.scan

                controller_list=[]
                
                Rails.application.routes.routes.map do |route|
                    route.defaults[:controller]
                end.uniq.each do |controller|
                    next if controller.blank?
                    next if controller.include? "rails"
                    next if controller.include? "action_mailbox"
                    next if controller.include? "active_storage"
                    controller_list.push({ module: "Core", bucket: controller })
                end

                Rails.configuration.lesli_settings["engines"].each do |engine|
                    routes = "#{engine["name"]}::Engine".constantize.routes.routes
                    routes.map do |route|
                        route.defaults[:controller]
                    end.uniq.map do |controller|
                        next if controller.blank?
                        controller = controller.sub(engine["code"] + '/', '')
                        controller_list.push({ module: engine["name"], bucket: controller })
                    end
                end

                return controller_list

            end

        end

    end

end
