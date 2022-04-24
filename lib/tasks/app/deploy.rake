=begin

Lesli

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

namespace :app do

    namespace :deploy do

        desc "Sends a first access link to 'owner' users for new accounts"
        task send_first_access_links: :environment do
            instance = Rails.application.config.lesli["instance"][:name]
            account = Account.find_by(company_name: Rails.application.config.lesli["account"]["company"]["name"])

            next unless account
            next unless instance == "Lesli" || instance == "LesliCloud"
            next unless account.onboarding?

            account.users.joins(:user_roles => :roles).where("roles.name = ?", "owner").each do |user|
                puts "Sending a first access link to user #{user.email}"

                # We generate and send a first access link to owner users only
                pass = user.access_codes.new({ token_type: "pass" })
                raw, enc = Devise.token_generator.generate(pass.class, :token)
                pass.token = enc

                if pass.save

                    user.logs.create({
                        title: "pass_creation_successful",
                        description: "pass_for_initial_login_link"
                    })

                    UserMailer.with(user: user, token: raw).pass_instructions(template_name: "first_access").deliver_now
                else
                    user.logs.create({
                        title: "pass_creation_error",
                        description: pass.errors.full_messages.to_sentence
                    })
                end
            end
        end

        task after: :environment do
            Rake::Task["cloud_babel:scan"].invoke if defined?(CloudBabel)
            Rake::Task["app:controllers:build"].invoke 
            Rake::Task["app:engines:initialize_account"].invoke
        end



    end

end
