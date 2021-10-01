=begin

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

scp -i app.mitwerken.de.pem ubuntu@app.mitwerken.de:/var/www/app.mitwerken.de/config/credentials/production.key production.key
scp -i app.mitwerken.de.pem ubuntu@app.mitwerken.de:/var/www/app.mitwerken.de/config/credentials/production.yml.enc production.yml.enc


scp -i app.mitwerken.de.pem production.key ubuntu@app.mitwerken.de:/var/www/app.mitwerken.de/config/credentials/production.key
scp -i app.mitwerken.de.pem production.yml.enc ubuntu@app.mitwerken.de:/var/www/app.mitwerken.de/config/credentials/production.yml.enc

=end

require "./lesli"

namespace :dev do

    namespace :app do

        desc "Lesli reset app installation"
        task reset: :environment do

            #aws s3 sync . s3://crmleibrentenstorage/migration --profile beta

            #datetime_start = Time.now.strftime('%Y/%m/%d %H:%M:%S')
            #file = File.open(Rails.root.join("public", "dev-deploy-log.txt"), "a")
            #file.write("Deploy process started at: #{ datetime_start }, ")
            #file.close

            #system "service nginx stop"

            #system "bundle install"

            system "git checkout ."

            Rake::Task["dev:git:pull"].invoke

            #system "gem install bundler"
            #system "bundle install"

            system "rake dev:git:pull RAILS_ENV=production" 

            system "rake db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 RAILS_ENV=production" 
            system "rake db:create RAILS_ENV=production" 
            system "rake db:migrate RAILS_ENV=production" 
            system "rake db:seed RAILS_ENV=production" 

            # sudo chmod 755 public/ -R
            # sudo chown ubuntu public/ -R

            system "bundle exec rake assets:clean RAILS_ENV=production"
            system "bundle exec rake assets:precompile RAILS_ENV=production"
            system "bundle exec rake i18n:js:export RAILS_ENV=production"

            #system "whenever --update-crontab"
            
            #system "sudo chmod 755 public/ -R"
            #system "sudo chmod 777 public/ -R"
            #system "sudo chown www-data:www-data public/ -R"

            #system "sudo service nginx restart"

            #chmod 755 public/ -R && chown www-data:www-data public/ -R && service nginx restart
            #du -chs engines/**/app/assets/javascripts/**/*.js app/assets/javascripts/**/*.js | sort -h

            #du -chs storage/**/**/*.* | sort -h

            #du -sh * | sort -h

            #find . -type f -printf "%s\t%p\n" | sort -n | tail -1

            # DO NOT UPDATE TO CHANGE FOLDER PERMISSION AFTER RESTART NGINX
            # sudo chmod 755 public/ -R
            # sudo chown www-data:www-data public/ -R
            # and run bundle install if you are cloning the repo from scratch
            # nohup command &>/dev/null &
            # nohup RAILS_ENV=production rake haus:import &>/dev/null &
            # nohup rake haus:import RAILS_ENV=production &
            # touch tmp/restart.txt
            # sudo -u username

            # ojdXzyxsms4vphsrUBtu
            # OULztdkk5h4RMS5n19Sg

            #dev.lesli.cloud zdnjs5Hoeh6rAWxzeeUt

        end

        desc "List available engines"
        task engines: :environment do
            p "Available engines:"
            Lesli::engines.each do |engine|
                p engine
            end
        end

        desc "List available engines"
        task settings: :environment do
            p Lesli::settings
        end

        desc "Clean javascript cache from rails"
        task rmjs: :environment do

            Lesli::engines.each do |engine|
                engine_path = Rails.root.join('engines', engine['name'], "app", "assets", "javascripts")
                FileUtils.rm_rf(engine_path)
                p "delete folder: #{engine_path.to_s}"
            end

        end

        task test_mail: :environment do
            LesliMailer.test().deliver_now
        end

    end

end
