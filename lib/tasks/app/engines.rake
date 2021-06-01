namespace :app do
    namespace :engines do

        desc "Add account for new engines added to existing instance"
        task initialize_account: :environment do

            Account.all.each do |account|
                account.initialize_account_for_engines
            end

            puts "Done - engines accounts initialized"

        end
    end
end
