namespace :babel do

    task scan: :environment do
        Rake::Task["cloud_babel:scan"].invoke
    end

    task generate: :environment do
        Rake::Task["cloud_babel:generate"].invoke
    end

    task clean: :environment do
        Rake::Task["cloud_babel:clean"].invoke
    end

end
