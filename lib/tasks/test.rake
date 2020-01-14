namespace :test do

    desc "Prepare environment to run tests"
    task prepare: :environment do
        ENV["RAILS_ENV"] = "test"
        Rake::Task["dev:db:reset"].invoke
    end

    desc "Run all the tests"
    task run: :environment do
        system "rspec spec"
    end

end
