namespace :dev do

    desc ""
    task translations: :environment do

        translation_files = Dir[Rails.root.join('config', 'locales', '**','**','**','**')]
        translation_files = Dir[Rails.root.join('config', 'locales', '*')]

        entries = YAML.load_file(translation_files[2]).first

        lang = entries[0]
        name_space = ''

        translation_file = Translation.find_or_create_by({
            file: translation_files[2]
        })

        def recursive_entry(entries, name_space, fileid)
            if entries.is_a?(Array)
                if entries[1].is_a?(Hash)
                    name_space = name_space + entries.first + '.'
                    recursive_entry(entries[1], name_space, fileid)
                else
                    TranslationString.create({
                        entry: name_space + entries[0],
                        lang_en: entries[1],
                        translations_id: fileid
                    })
                end
            end

            if entries.is_a?(Hash)
                entries.each do |entry|
                    if entry.is_a?(Array)
                        recursive_entry(entry, name_space, fileid)
                    end
                end
            end

        end

        recursive_entry(entries[1], lang + '.', translation_file.id)

    end

    desc ""
    task translation_generate: :environment do

        translation_strings = []
        translation_strings_raw = TranslationString.all

        translation_strings_raw.each_with_index do |string, index|
            translation_strings.push({
                "#{string.entry}": string.lang_en
            })
        end

        File.open(Rails.root.join("test.yml"), "w") do |file|
            file.write(translation_strings.to_yaml)
        end

    end

    namespace :git do

        desc "Push everything to github master"
        task push: :environment do

            system "rm -r vendor/*"
            system "cp node_modules/bulma/ vendor/ -ra"
            system "cp node_modules/bulma-extensions/ vendor/ -ra"
            system "cp node_modules/buefy/ vendor/ -ra"
            system "cp node_modules/lesli-css/ vendor/ -ra"
            system "cp node_modules/@fullcalendar/ vendor/ -ra"

            system "git add --all && git commit -m \"Update vendors\""

            system "cd ./engines/CloudBell && git push github master"
            system "cd ./engines/CloudBooks && git push github master"
            system "cd ./engines/CloudCourier && git push github master"
            system "cd ./engines/CloudDev && git push github master"
            system "cd ./engines/CloudDriver && git push github master"
            system "cd ./engines/CloudHelp && git push github master"
            system "cd ./engines/CloudKb && git push github master"
            system "cd ./engines/CloudLesli && git push github master"
            system "cd ./engines/CloudLock && git push github master"
            system "cd ./engines/CloudPanel && git push github master"
            system "cd ./engines/CloudTeam && git push github master"
            
            system "git push github master"

        end

        desc "Pull everything from github master"
        task pull: :environment do

            system "cd ./engines/CloudBell && git pull github master"
            system "cd ./engines/CloudBooks && git pull github master"
            system "cd ./engines/CloudCourier && git pull github master"
            system "cd ./engines/CloudDev && git pull github master"
            system "cd ./engines/CloudDriver && git pull github master"
            system "cd ./engines/CloudHelp && git pull github master"
            system "cd ./engines/CloudKb && git pull github master"
            system "cd ./engines/CloudLesli && git pull github master"
            system "cd ./engines/CloudLock && git pull github master"
            system "cd ./engines/CloudPanel && git pull github master"
            system "cd ./engines/CloudTeam && git pull github master"

            system "git pull github master"

        end

    end

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

    namespace :app do

        desc "LesliCloud fresh installation"
        task install: :environment do

            system "sudo service nginx stop"
            system "git checkout ."
            system "git pull origin master --no-edit"
            system "cd ./engines/CloudBell && git pull origin master --no-edit"
            system "cd ./engines/CloudBooks && git pull origin master --no-edit"
            system "cd ./engines/CloudCourier && git pull origin master --no-edit"
            system "cd ./engines/CloudDriver && git pull origin master --no-edit"
            system "cd ./engines/CloudHelp && git pull origin master --no-edit"
            system "cd ./engines/CloudKb && git pull origin master --no-edit"
            system "cd ./engines/CloudLesli && git pull origin master --no-edit"
            system "cd ./engines/CloudLock && git pull origin master --no-edit"
            system "cd ./engines/CloudPanel && git pull origin master --no-edit"
            system "cd ./engines/CloudTeam && git pull origin master --no-edit"

            #system "rvm use default"
            system "gem install bundler"
            system "bundle install"

            system "rake db:drop RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
            system "rake db:create RAILS_ENV=production" 
            system "rake db:migrate RAILS_ENV=production" 
            system "rake db:seed RAILS_ENV=production" 

            system "whenever --update-crontab"

            system "bundle exec rake assets:clean RAILS_ENV=production"
            system "bundle exec rake assets:precompile RAILS_ENV=production"
            
            system "sudo service nginx restart"

        end

    end

end
