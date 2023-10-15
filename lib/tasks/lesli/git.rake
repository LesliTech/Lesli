=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# · 
namespace :lesli do 
    namespace :git do

        desc "Update vendor from node_modules"
        task :vendor => :environment do |task, args|
            vendor()
        end
    end

    def vendor

        # copy vendor dependencies (only css files are required)
        FileUtils.rm_rf("engines/Lesli/vendor")
        FileUtils.mkdir("engines/Lesli/vendor")
    
        # updated version of libraries
        [
            "bulma",
            "lesli-css",
            "remixicon"
        ].each do |package|
            FileUtils.cp_r "engines/Lesli/node_modules/#{package}/", "engines/Lesli/vendor/#{package}", :verbose => true
            FileUtils.rm_rf("engines/Lesli/vendor/#{package}/.git")
        end
    
        Dir.glob("engines/Lesli/vendor/**/*").each do |file|
            next if file.end_with?(".css")
            next if file.end_with?(".scss")
            next if file.end_with?(".sass")
            next if file.end_with?("LICENSE")
            next if file.end_with?("License")
            next if file.end_with?("license")
            next if File.directory?(file)
            FileUtils.rm(file, :verbose => true) 
        end

        # commit any change in vendor
        # command("git add vendor && git commit -m \"vendor: update npm dependencies (vendors)\" vendor")
    
    end
end
