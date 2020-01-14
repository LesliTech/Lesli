
namespace :dev do

    def get_engines
        [{
            name: 'CloudBabel',
            code: 'cloud_babel',
            github_ssh: 'git@github.com:LesliTech/CloudBabel.git',
            github_url: 'https://github.com/LesliTech/CloudBabel'
        }]
    end

    namespace :git do

        desc "Push everything to github master"
        task push: :environment do

            # ensure all engines have github remote origin
            Rake::Task["dev:git:add_github_origin"].invoke

            engines = get_engines

            # push all engines
            engines.each do |engine|
                engine_path = Rails.root.join('engines', engine[:name])
                system "cd ./engines/#{engine[:name]} && git push github master" if File.exists?(engine_path)
            end
            
            # commit any possible pending change
            system "git add --all && git commit -m \"Dev update\""

            # copy vendor dependencies (only css files are required)
            system "rm -r vendor/*"
            system "cp node_modules/buefy/ vendor/ -ra"
            system "cp node_modules/bulma/ vendor/ -ra"
            system "cp node_modules/bulma-extensions/ vendor/ -ra"
            system "cp node_modules/quill/ vendor/ -ra"
            system "cp node_modules/@fullcalendar/ vendor/ -ra"
            system "cp node_modules/lesli-css/ vendor/ -ra"

            # commit any change in vendor
            system "git add --all && git commit -m \"Update npm dependencies (vendors)\""
    
            # push core to github
            system "git push github master"

        end

        desc "Pull everything from github master"
        task pull: :environment do

            Rake::Task["dev:git:rename_origin"].invoke

            engines = get_engines

            engines.each do |engine|
                engine_path = Rails.root.join('engines', engine)
                system "cd ./engines/#{engine} && git pull github master" if File.exists?(engine_path)
            end

            system "git pull github master"

        end

        desc "Add github origin"
        task add_github_origin: :environment do

            engines = get_engines

            engines.each do |engine|

                # build engine path
                engine_path = Rails.root.join('engines', engine[:name])

                # next if engine folder does not exist
                next unless File.exists?(engine_path)

                # check if github remote exists
                next if system "cd ./engines/#{engine[:name]} && git remote show github" 

                system "cd ./engines/#{engine[:name]} && git remote add origin github #{engine[:github_ssh]}" 

            end

            system "git pull github master"

        end

    end

end
