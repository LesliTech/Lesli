namespace :haus do

    task import: :environment do
        Rake::Task["deutsche_leibrenten:import:all"].invoke
    end

end
