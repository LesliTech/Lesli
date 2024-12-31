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


# · Usage
# · 
# · Lesli::Courier.new(:lesli_test).from(:ticket_service).call(:index_with_deadline)
# · Lesli::Courier.new(:lesli_test).from(:ticket_service).with(curent_user, query).call(:index)
# · Lesli::Courier.new(:lesli_test).from(:ticket_service).with(curent_user, query).call(:create, params)
# · 
# · Lesli::Courier.new(:lesli_test, []).from(:ticket_service).call(:index_with_deadline)
# · Lesli::Courier.new(:lesli_test, []).from(:ticket_service).with(curent_user, query).call(:index)
# · Lesli::Courier.new(:lesli_test, false).from(:ticket_service).with(curent_user, query).call(:create, params)
# · 
module Lesli
    class Courier

        # Store the module_name (e.g., :lesli_support as LesliSupport)
        def initialize(module_name, on_error=nil)
            @module_name = module_name.to_s.camelize
            @on_error=on_error
        end

        # Dynamically determine the class to call (e.g., :ticket_service as TicketService)
        def from(service_name, *args)
            @service_params = args
            @service_name = service_name.to_s.camelize
            self
        end

        # Store the method name to call on the service (e.g., :index_with_deadline)
        def call(method_name, *args)
            @method_params = args 
            @method_name = method_name
            self.execute
        end

        private 

        # Execute the final call to the service, either with or without params
        def execute

            module_name = "#{@module_name}"

            # Look up the module and class dynamically
            return @on_error unless Object.const_defined?(module_name)

            module_service_name = "#{@module_name}::#{@service_name}"

            return @on_error unless Object.const_defined?(module_service_name)

            # Create a reference of the module service object
            module_service_class = module_service_name.constantize
            
            # Instantiate the service class with or without arguments
            module_service_instance = module_service_class.new(*@service_params.to_a) 

            # Check if the method is defined on the service instance
            return @on_error unless module_service_instance.respond_to?(@method_name)

            # Dynamically call the method on the service instance
            module_service_instance.send(@method_name)
        end
    end
end
