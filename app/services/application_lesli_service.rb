=begin

Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

class ApplicationLesliService


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

        @query = query
    end


    # Find an specific resource through the main id
    def find id
        # Look for the resource in the database
        # self.resource = current_user.account.users.find_by_id(id) # example

        # Should always return self
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
