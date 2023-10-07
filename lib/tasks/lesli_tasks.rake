
require "L2"
require_relative "db"

namespace :lesli do 
    namespace :db do

        desc "Drop, build, migrate & seed Lesli database (development only)"
        task :reset => :environment do |task, args|
            reset()
        end

        desc "Build, migrate & seed Lesli database"
        task :setup => :environment do |task, args|
            setup()
        end

        desc "Build, migrate & seed Lesli database"
        task :seed => :environment do |task, args|
            seed()
        end
    end
    namespace :babel do 
        desc "Scan and register labels"
        task :build => :environment do |task, args|
            Rake::Task['lesli_babel:build'].invoke
        end 
    end
end
