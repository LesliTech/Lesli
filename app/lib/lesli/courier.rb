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

        rescue 
            return @on_error
        end
    end
end
