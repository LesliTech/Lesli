namespace :lock do

    task scan: :environment do
        Rake::Task["cloud_lock:scan"].invoke
    end

end
