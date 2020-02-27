namespace :haus do

    task import: :environment do
        Rake::Task["cloud_haus:import:cloud_driver"].invoke
    end

end
