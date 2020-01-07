namespace :babel do

    task scan: :environment do
        Rake::Task["cloud_babel:scan"].invoke
    end

    task build: :environment do
        Rake::Task["cloud_babel:build"].invoke
    end

end
