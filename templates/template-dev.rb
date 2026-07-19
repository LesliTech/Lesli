=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end



# Usage:
#   rails new LesliDemo --skip-bundle \
#     -m https://raw.githubusercontent.com/LesliTech/Lesli/master/templates/template-dev.rb
#
# DEVELOPMENT ONLY:
# This template clones mutable source code from the master branch of every
# Lesli repository. Use a versioned template and released gems for production.



# Tell users what they are about to install before executing remote commands.
say_status :warning, "Development template: cloning Lesli source from master", :yellow



# List of engines to install
LESLI_ENGINES = [
    "Lesli", 
    "LesliBell", 
    "LesliAdmin", 
    "LesliBabel", 
    "LesliAudit", 
    "LesliShield",
    "LesliSupport", 
    "LesliCalendar", 
    "LesliDashboard"
].freeze



# List of gems to install
LESLI_GEMS = [
    "LesliDate",
    "LesliView",
    "LesliAssets",
    "LesliSystem"
].freeze



# Reusable method to install packages
def install_lesli_package(folder, package_name)

    # Convert the repository name into the snake_case name used by RubyGems.
    package_code = package_name.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
    destination = "#{folder}/#{package_name}"
    repository = "https://github.com/LesliTech/#{package_name}.git"

    # HTTPS works for public users without requiring configured GitHub SSH keys.
    empty_directory(folder)
    run(
        %(git clone --depth 1 --branch master #{repository} #{destination}),
        abort_on_failure: true
    )

    # Load the cloned package directly from its source directory.
    gem package_code, path: destination
end



# Install dependencies
LESLI_ENGINES.each { |engine_name| install_lesli_package("engines", engine_name) }
LESLI_GEMS.each { |gem_name| install_lesli_package("gems", gem_name) }



# Install general gems
say_status :bundle, "Installing gems", :blue
run "bundle install", abort_on_failure: true



# Run Lesli installer
say_status :lesli, "Running rails generate lesli:install", :blue
generate "lesli:install"



# Enable demo mode only after verifying the generator created the expected setting.
initializer = "config/initializers/lesli.rb"
demo_setting = "config.demo = false"

unless File.exist?(initializer) && File.read(initializer).include?(demo_setting)
    raise "Unable to enable demo mode: #{initializer} does not contain #{demo_setting.inspect}"
end

gsub_file initializer, demo_setting, "config.demo = true"



# This is a newly generated demo application, so rebuild and seed its database.
# Never reuse this development template against an application with existing data.
say_status :lesli, "Rebuilding and seeding the demo database", :blue
run "bin/rails lesli:db:rebuild", abort_on_failure: true



# Installation completed!
say_status :done, "Lesli demo app ready ✅", :green
say_status :start, "Run bin/rails server and visit http://127.0.0.1:3000/login", :green
