namespace :data do
    namespace :import do

        def read_file filename
            path = Rails.root.join("storage", "#{filename}.json")
            abort "Input file not found: #{filename}" unless File.exist?(path) 
            JSON.parse(File.read(path))
        end

        desc "Employees Json to Core_Employees"
        task core_employees: :environment do
            account = Account.find_by_id(1)
            data = read_file("employees")
            data.each_with_index do |item, index|
                puts "processing task #{index} of #{data.length}"
                if User.all.exists?(:email => item['email'])
                    user = User.find_by_email item['email']
                    puts " - already exists: #{user.email}"
                else
                    user = User.new
                    user.email = item['email']
                    user.password = item['encrypted_password']
                    user.password_confirmation = item['encrypted_password']
                    user.reset_password_token = item['reset_password_token']
                    user.reset_password_sent_at = item['reset_password_sent_at']
                    user.remember_created_at = item['remember_created_at']
                    user.sign_in_count = item['sign_in_count']
                    user.current_sign_in_at = item['current_sign_in_at']
                    user.last_sign_in_at = item['last_sign_in_at']
                    user.current_sign_in_ip = item['current_sign_in_ip']
                    user.last_sign_in_ip = item['last_sign_in_ip']
                    # user. ? = item['role']
                    # user. ? = item['person_id']
                    # user. ? = item['employee_id']
                    user.created_at = item['created_at']
                    user.updated_at = item['updated_at']
                    user.accounts_id = account.id
                    user.save!
                    ActiveRecord::Base.connection.exec_query("UPDATE public.users
                        SET encrypted_password='#{item['encrypted_password']}'
                        WHERE email='#{item['email']}';
                    ")
                    puts " - added #{item['email']}"
                end
            end
            puts "- imported #{data.length} users"
        end

        # desc "Companies Json to Table"
        # task core_cloud_house_companies: :environment do
        #     data = read_file("crm_companies")
        #     data.each_with_index do |item, index|
        #         puts "processing task #{index} of #{data.length}"
        #         if CloudHouse::Company.all.exists?(:name => item['name'])
        #             company = Company.find_by_name item['name']
        #             puts " - already exists: #{company.name}"
        #         else
        #             company = Company.new
        #             company.name = item['name']
        #             company. = item['contact_function']
        #             company. = item['legal_form']
        #             company. = item['hq_email']
        #             company. = item['hq_phone']
        #             company. = item['hq_fax']
        #             company. = item['brokerage']
        #             company. = item['street_name']
        #             company. = item['street_number']
        #             company. = item['street_other']
        #             company. = item['postcode']
        #             company. = item['city_id']
        #             company. = item['website']
        #             company. = item['ivd']
        #             company. = item['bvfi']
        #             company. = item['franchise']
        #             company. = item['region']
        #             company. = item['founded_at']
        #             company. = item['description']
        #             company. = item['business_turn_id']
        #             company. = item['person_id']
        #             company. = item['latitude']
        #             company. = item['longitude']
        #             company. = item['cooperation_agreement']
        #             company. = item['contracting_partner']
        #             company. = item['cooperation_agreement_start']
        #             company. = item['cooperation_agreement_end']
        #             company. = item['distributor_since']
        #             company. = item['cooperation_limited_to']
        #             company. = item['market_region_designed']
        #             company. = item['active_cooperation']
        #             company. = item['commission_rate']
        #             company. = item['premium_partner']
        #             company. = item['specific_agreement']
        #             company. = item['avv_shipped']
        #             company. = item['avv_completed']
        #             company. = item['created_at']
        #             company. = item['updated_at']
        #             company. = item['last_activity']
        #             company. = item['observation']
        #             company. = item['deleted_at']
        #             company. = item['company_id']
        #             company. = item['aasm_status']
        #             company. = item['city_name']
        #             company.save!
        #             puts " - added #{company.name}"
        #         end
        #     end
        #     puts "- imported #{data.length} companies"
        # end


        desc ""
        task tasks: :environment do
            account = Account.find(1)
            tasks = read_file("crm_tasks")
            tasks.each_with_index do |task, index|
                p "processing task #{index} of #{tasks.length}"
                CloudFocus::Task.create({
                    detail_attributes: {
                        title: task['title'],
                        description: task['note'],
                        deadline: task['deadline']
                    },
                    account: account
                })
            end
        end

    end
end
