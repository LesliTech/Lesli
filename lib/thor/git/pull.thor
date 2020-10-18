
class Git < Thor
    desc 'install', 'Install something'
    def pull
        puts "Using lib/thor/git/pull.thor file"
    end
end
=begin
desc "Pull everything from github master"
task pull: :environment do

    Lesli::engines.each do |engine|

        # build engine path
        engine_path = Rails.root.join('engines', engine['name'])

        # pull from master
        puts ""; puts ""; puts "";
        puts "Working with: #{engine['name']}"
        result = `cd ./engines/#{engine['name']} && git pull origin master` if File.exists?(engine_path)

    end

    # pull from master
    puts ""; puts ""; puts "";
    puts "Working with: Lesli"
    system "git pull origin master"

end
=end
