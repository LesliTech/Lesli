namespace :haus do

    task import: :environment do
        Rake::Task["cloud_haus:import:all"].invoke
    end

end
