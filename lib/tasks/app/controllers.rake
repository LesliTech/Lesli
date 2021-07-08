
namespace :app do
    namespace :controllers do

        desc "Scan new routes added and create role privileges"
        task build: :environment do
            puts  "START SCAN AT: #{Time.now}"

            company_name = Rails.application.config.lesli_settings["account"]["company"]["name"]
            account = Account.find_by(company_name: company_name)

            # get all routes for application controllers
            controllers = LC::System::Controllers.scan

            threads = []

            controllers.each do |controller_name, value|
                controller = SystemController.find_or_initialize_by(name: controller_name)

                if (controller.save)
                    value[:actions].each do |action|
                        system_action = controller.actions.find_or_initialize_by(name: action)

                        if (system_action.new_record?)
                            if (system_action.save)

                                puts "action #{action} created for controller: #{controller_name}"

                                account.role_descriptors.each do |descriptor|
                                    if (descriptor.name == "owner"||descriptor.name == "admin")
                                        threads << Thread.new do
                                            role_descriptor_action = descriptor.privilege_actions.new(system_action: system_action, status: true)

                                            role_descriptor_action.save
                                        end
                                        
                                        threads.map { |thread| thread.join }
                                    end 
                                end
                            end
                        end
                    end
                end
            end

            puts  "FINISH SCAN AT: #{Time.now}"
        end
    end
end
