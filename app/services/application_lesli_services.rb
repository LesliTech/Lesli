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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

# · 
class ApplicationLesliServices


    # Set container attributes to manage the life-cycle of the service
    @query;
    @resource;
    @failures;
    @current_user;


    # Service constructor
    # current_user is always required to initialize a service object
    # current user is used to get the data only from the account context
    def initialize current_user, query={}

        # make the current user globaly available in the service object
        @current_user = current_user

        # stores the resources from the database as result of the active record queries
        @resource = nil

        # stores any error found during the life-cycle of the service object
        @failures = []

        # standard conditions to query the database
        @query = query
    end


    # Find an specific resource through the main id
    def find resource = nil
        # Look for the resource in the database
        # self.resource = current_user.account.users.find_by_id(id) # example

        # Should always return self
        self.resource = resource if resource
        self
    end


    # Standard method to list data from the database
    def list params=nil
    end


    # Standard method to index data from the database
    def index params=nil
    end


    # Standard method to show data from the database
    def show
    end


    # Standard method to create new resource into the database
    def create params
        # Example:
        # user = current_user.account.users.new(params)

        # if user.save
        #     self.resource = user
        # else
        #     self.error(user.errors.full_messages.to_sentence)
        # end

        self
    end


    # Standard method to update resources into the database
    def update params
    end


    # Standard method to delete data from the database
    def delete
    end


    # Method to check if the service object has data available
    # this method ment to be used together and after the find method
    def found?
        !self.resource.blank?
    end


    # Check if the service object has errors
    def successful?
        self.failures.empty?
    end


    # Get the list of erros
    def errors
        self.failures
    end


    # Get the list of erros as single string
    def errors_as_sentence
        self.failures.to_sentence
    end


    # Register a new error for the current service object
    def error error
        self.failures.push(error)
    end


    # Return the resource as a result
    def result
        self.resource
    end

    private

    attr_reader :current_user

    attr_reader :resource
    attr_writer :resource

    attr_reader :successful
    attr_writer :successful

    attr_reader :failures
    attr_writer :failures

    attr_reader :query
end
