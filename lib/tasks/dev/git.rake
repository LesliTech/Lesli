namespace :dev do

    def get_engines
        [
            'CloudTeam',
            'CloudHappy',
            'CloudSeller',
            'CloudLeaf',
            'CloudDrop',
            'CloudMailer',
            'CloudDriver',
            'CloudChaos',
            'CloudClock',
            'CloudPizza',
            'CloudNotes',
            'CloudLesli',
            'CloudSocial',
            'CloudBell',
            'CloudBooks',
            'CloudWallet',
            'CloudThings',
            'CloudKb',
            'CloudHelp',
            'CloudPortal',
            'CloudBug',
            'CloudPanel',
            'CloudLock',
            'CloudBabel'
        ]
    end

    namespace :git do

        desc "Push everything to github master"
        task push: :environment do

            Rake::Task["dev:git:rename_origin"].invoke

            engines = get_engines

            engines.each do |engine|
                engine_path = Rails.root.join('engines', engine)
                system "cd ./engines/#{engine} && git push github master" if File.exists?(engine_path)
            end
            
            system "git add --all && git commit -m \"Dev update\""

            system "rm -r vendor/*"
            system "cp node_modules/buefy/ vendor/ -ra"
            system "cp node_modules/bulma/ vendor/ -ra"
            system "cp node_modules/bulma-extensions/ vendor/ -ra"

            system "cp node_modules/quill/ vendor/ -ra"

            system "cp node_modules/@fullcalendar/ vendor/ -ra"
            system "cp node_modules/lesli-css/ vendor/ -ra"

            system "git add --all && git commit -m \"Update npm dependencies (vendors)\""
            
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

        desc "Rename remote origin"
        task rename_origin: :environment do

            engines = get_engines

            engines.each do |engine|
                engine_path = Rails.root.join('engines', engine)
                system "cd ./engines/#{engine} && git remote rename origin github" if File.exists?(engine_path)
            end

            system "git pull github master"

        end

    end

end
