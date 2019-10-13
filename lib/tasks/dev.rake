namespace :dev do

    desc "TODO"
    task push: :environment do

        system "rm -r vendor/*"
        system "cp node_modules/lesli-css/ vendor/ -ra"
        system "cp node_modules/bulma/ vendor/ -ra"
        system "cp node_modules/buefy/ vendor/ -ra"
        system "git add --all && git commit -m \"Updatin vendors\""

        system "cd ./engines/CloudBell"
        system "git push github master"

        system "cd ./engines/CloudBooks"
        system "git push github master"

        system "cd ./engines/CloudCourier"
        system "git push github master"

        system "cd ./engines/CloudDriver"
        system "git push github master"

        system "cd ./engines/CloudHelp"
        system "git push github master"

        system "cd ./engines/CloudKb"
        system "git push github master"

        system "cd ./engines/CloudLesli"
        system "git push github master"

        system "cd ./engines/CloudLock"
        system "git push github master"

        system "cd ./engines/CloudPanel"
        system "git push github master"

        system "cd ./engines/CloudTeam"
        system "git push github master"

        system "git push github master"

    end

    desc "TODO"
    task install: :environment do

        system "git pull origin master --no-edit"

        system "cd ./engines/CloudBell"
        system "git pull origin master --no-edit"

        system "cd ./engines/CloudBooks"
        system "git pull origin master --no-edit"

        system "cd ./engines/CloudCourier"
        system "git pull origin master --no-edit"

        system "cd ./engines/CloudDriver"
        system "git pull origin master --no-edit"

        system "cd ./engines/CloudHelp"
        system "git pull origin master --no-edit"

        system "cd ./engines/CloudKb"
        system "git pull origin master --no-edit"

        system "cd ./engines/CloudLesli"
        system "git pull origin master --no-edit"

        system "cd ./engines/CloudLock"
        system "git pull origin master --no-edit"

        system "cd ./engines/CloudPanel"
        system "git pull origin master --no-edit"

        system "cd ./engines/CloudTeam"
        system "git pull origin master --no-edit"

        system "cd ."

        system "rvm use default"
        system "gem install bundler"
        system "bundle install"

        Rake::Task["db:drop"].invoke
        Rake::Task["db:create"].invoke
        Rake::Task["db:migrate"].invoke
        Rake::Task["db:seed"].invoke

        system "bundle exec rake assets:clean RAILS_ENV=production"
        system "bundle exec rake assets:precompile RAILS_ENV=production"

        system "sudo service nginx restart"

    end
end
