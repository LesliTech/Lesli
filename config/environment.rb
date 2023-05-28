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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

# Lesli initialize validations

if Rails.const_defined?("Server")
    Rails.application.configure do

        errors = []

        # Essentials, we must provide a database connection
        errors.push("Error with database credentials") if !Rails.application.credentials.config.has_key?(:db)
        errors.push("Error with database credentials") if !Rails.application.credentials.db.has_key?(:database)
        errors.push("Error with database credentials") if !Rails.application.credentials.db.has_key?(:username)
        errors.push("Error with database credentials") if !Rails.application.credentials.db.has_key?(:password)

        # exit execution if there are errors
        if errors.size > 0
            L2.fatal(*errors);  exit;
        end

        # instance name from builder
        instance = Rails.application.config.lesli.dig(:instance, :name)

        # get version and build number
        revision = Lesli::System.revision()

        # get installed engines
        engines = Lesli::System.engines().map { |engine| {
            :engine => engine[:code], :version => "#{engine[:version]} (#{engine[:type]})"
        }}

        # print pretty instance information 

        L2.br(4)

        # core information
        L2.m("Lesli: ", "Version: " << Lesli::VERSION, "Build: " << Lesli::BUILD)

        L2.br()

        # builder information
        L2.m("Instance: " << instance, "Version: " << revision[:version], "Build: " << revision[:build])

        L2.br(2)

        # print list of engines
        L2.table(engines)

        L2.br(2)

    end
end
