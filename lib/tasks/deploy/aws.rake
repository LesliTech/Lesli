namespace :deploy do
    desc "Reboots the production instance configured in the credentials"
    task reboot_production_instance: :environment do
        ec2_credentials = Rails.application.credentials.providers[:aws][:ec2]

        if ec2_credentials[:instances] && ec2_credentials[:instances][:production]
            ec2_client = LC::Config::Providers::Aws::Ec2.new
            puts "Initiating reboot process. Please wait, this may take a minute."
            if ec2_client.reboot_instance(ec2_credentials[:instances][:production])
                puts "Reboot process complete..."
            else
                puts "Reboot process failed..."
            end
        else
            puts "Production instance is not set in the rails credentials. Task cannot continue."
            puts "Please configure Rails.application.credentials.providers[:aws][:ec2][:instances][:production] and try again."
        end
    end
end
