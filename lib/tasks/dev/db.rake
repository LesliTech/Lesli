namespace :dev do

    namespace :db do

        desc "Database hard-reset"
        task reset: :environment do
            
            system "rails db:environment:set RAILS_ENV=development"
            system "rake db:drop RAILS_ENV=development" 
            system "rake db:create RAILS_ENV=development" 
            system "rake db:migrate RAILS_ENV=development" 
            system "rake db:seed RAILS_ENV=development" 

        end

    end

end
