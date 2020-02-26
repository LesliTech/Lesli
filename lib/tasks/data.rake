namespace :data do
    namespace :import do

        def read_file filename
            path = Rails.root.join("storage", "#{filename}.json")
            abort "Input file not found: #{filename}" unless File.exist?(path) 
            JSON.parse(File.read(path))
        end

        desc "Run all import tasks"
        task :run_all => :environment do
            Rake::Task['data:import:core_employees'].execute
            Rake::Task['data:import:core_cloud_house_companies'].execute
            puts " --- all tasks done successfully"
        end

        desc "Employees Json to Core_Employees"
        task core_employees: :environment do
            account = Account.find_by_id(1)
            data = read_file("employees")
            data.each_with_index do |item, index|
                if item['email'].include? "@lomax.com.gt"
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
            end
            puts "- imported #{data.length} users"
        end

        desc "Task Json to Core Cloud Focus Task"
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

        desc "Companies Json to Core Cloud House Companies and Company Details"
        task core_cloud_house_companies: :environment do
            account = Account.find(1)
            data = read_file("crm_companies")
            data.each_with_index do |item, index|
                puts "processing task #{index} of #{data.length}"

                company = CloudHouse::Company.new
                company.created_at = item['created_at']
                company.updated_at = item['updated_at']
                company.cloud_house_accounts_id = account.id
                # company.cloud_house_companies_id = ?
                # company.cloud_house_workflow_statuses_id = ?
                # company.cloud_house_employees_id = ?
                company.save!

                company_detail = CloudHouse::Company::Detail.new
                company_detail.name = item['name']
                company_detail.contact_function = item['contact_function']
                company_detail.legal_form = item['legal_form']
                company_detail.email = item['hq_email']
                company_detail.phone = item['hq_phone']
                company_detail.fax = item['hq_fax']
                company_detail.brokerage = item['brokerage']
                company_detail.street_name = item['street_name']
                company_detail.street_number = item['street_number']
                company_detail.street_other = item['street_other']
                company_detail.postcode = item['postcode']
                company_detail.city_name = item['city_name']
                company_detail.website = item['website']
                company_detail.ivd_member = item['ivd']
                company_detail.bvfi_member = item['bvfi']
                company_detail.franchise = item['franchise']
                company_detail.region = item['region']
                company_detail.founded_at = item['founded_at']
                company_detail.description = item['description']
                company_detail.latitude = item['latitude']
                company_detail.longitude = item['longitude']
                company_detail.cooperation_agreement = item['cooperation_agreement']
                company_detail.contracting_partner = item['contracting_partner']
                company_detail.cooperation_agreement_start = item['cooperation_agreement_start']
                company_detail.cooperation_agreement_end = item['cooperation_agreement_end']
                company_detail.distributor_since = item['distributor_since']
                company_detail.cooperation_limited_to = item['cooperation_limited_to']
                company_detail.market_region_designed = item['market_region_designed']
                company_detail.commission_rate = item['commission_rate']
                company_detail.premium_partner = item['premium_partner']
                company_detail.specific_agreement = item['specific_agreement']
                company_detail.avv_shipped = item['avv_shipped']
                company_detail.avv_completed = item['avv_completed']
                company_detail.cloud_house_companies_id = company.id
                company_detail.save!
                # company_detail. ? = item['last_activity']
                # company_detail. ? = item['observation']
                # company_detail. ? = item['deleted_at']
                # company_detail. ? = item['company_id']
                # company_detail. ? = item['aasm_status']
                # company_detail. ? = item['city_id']
                # company_detail. ? = item['business_turn_id']
                # company_detail. ? = item['person_id']
                # company_detail. ? = item['active_cooperation']
                puts " - added #{company_detail.name}"
                # item['person_id']
            end

            puts "- imported #{data.length} companies"
        end

    end
end
