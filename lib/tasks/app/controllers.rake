
namespace :app do
    namespace :controllers do

        desc "Scan new routes added and create role privileges"
        task build: :environment do
            puts  "START SCAN AT: #{Time.now}"

            company_name = Rails.application.config.lesli_settings["account"]["company"]["name"]

            account = Account.find_by(company_name: company_name)

            system_user = account.users.first

            # get all routes for application controllers
            controllers = LC::System::Controllers.scan

            threads = []

            controllers.each do |controller_name, value|
                controller = SystemController.find_or_initialize_by(name: controller_name)

                if (controller.save)
                    value[:actions].each do |action|
                        privilege_action = controller.actions.find_or_initialize_by(name: action)

                        if (privilege_action.new_record?)
                            if (privilege_action.save)

                                puts "action #{action} created for controller: #{controller_name}"

                                account.roles.each do |role|
                                    status = false
                                    status = true if (role.name == "admin" ||role.name == "owner")

                                    threads << Thread.new do
                                        role_privilege_action = role.privilege_actions.new(action: privilege_action, status: status)

                                        role_privilege_action.save
                                    end

                                    threads.map { |thread| thread.join }
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
