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

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

=begin

Usage:

# Example of service class
module LesliTest
    class TicketService
        def initialize(params = nil)
            @params = params
        end

        def index_with_deadline
            if @params
                "Processing ticket with params: #{@params}"
            else
                "Processing ticket without params"
            end
        end
    end
end

puts LesliCourier.new(:lesli_support2, "error").from(:ticket_service).with("my params").call(:index_with_deadline)
puts LesliCourier.new(:lesli_support2, "error").from(:ticket_service).call(:index_with_deadline)

puts LesliCourier.new(:lesli_test, "error").from(:ticket_service).with("my params").call(:index_with_deadline)
puts LesliCourier.new(:lesli_test, "error").from(:ticket_service).call(:index_with_deadline)

=end


# · 
class LesliCourier

    # Store the module_name (e.g., :lesli_support as LesliSupport)
    def initialize(module_name, on_error=nil)
        @module_name = module_name.to_s.camelize
        @on_error=on_error
    end

    # Dynamically determine the class to call (e.g., :ticket_service as TicketService)
    def from(service_name)
        @service_name = service_name.to_s.camelize
        self
    end

    # Call the dynamically constructed service method with optional arguments (via `with`)
    def with(*args)
        # Store the args for later use in the final call
        @args = args
        self
    end

    # Store the method name to call on the service (e.g., :index_with_deadline)
    def call(method_name)
        @method_name = method_name
        self.execute
    end

    # Execute the final call to the service, either with or without params
    def execute

        module_name = "#{@module_name}"

        # Look up the module and class dynamically
        return @on_error if !Object.const_defined?(module_name)

        module_service_name = "#{@module_name}::#{@service_name}"

        return @on_error if !Object.const_defined?(module_service_name)

        module_service_class = module_service_name.constantize
        
        # Instantiate the service class with or without arguments
        module_service_instance = module_service_class.new(*@args.to_a) 

        # Check if the method is defined on the service instance
        return @on_error unless module_service_instance.respond_to?(@method_name)

        # Dynamically call the method on the service instance
        module_service_instance.send(@method_name)
    end
end

