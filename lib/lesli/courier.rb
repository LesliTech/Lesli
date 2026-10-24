=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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

module Lesli
    class Courier

        # Configure the optional engine and its error behavior.
        #
        # module_name: engine module name as a String or Symbol.
        # fallback: value returned when the engine is unavailable or an error is handled.
        # fallback_on_error: return the fallback instead of raising execution errors.
        def initialize(module_name, fallback=nil, fallback_on_error: false)
            @module_name = module_name.to_s.camelize
            @fallback = fallback
            @fallback_on_error = fallback_on_error
        end

        # Select the class to instantiate (e.g., :ticket_service as TicketService),
        # store its constructor arguments, and return self to keep the call chainable.
        #
        # service_name: class name as a String or Symbol.
        # *args: positional arguments passed to the class constructor.
        # **kwargs: keyword arguments passed to the class constructor.
        def from(service_name, *args, **kwargs)
            @service_args = args
            @service_kwargs = kwargs
            @service_name = service_name.to_s.camelize
            self
        end

        # Select and execute a public method on the configured class instance.
        #
        # method_name: method name as a String or Symbol.
        # *args: positional arguments passed to the method.
        # **kwargs: keyword arguments passed to the method.
        # Returns the value returned by the invoked method.
        def call(method_name, *args, **kwargs)
            @method_args = args
            @method_kwargs = kwargs
            @method_name = method_name
            execute
        end

        private

        # The engine is always optional. Errors from an installed engine remain
        # visible unless the caller explicitly enables fallback_on_error.
        def execute
            # Resolve the configured engine name as a top-level Ruby module.
            engine_module = resolve_constant(Object, @module_name)

            # Return the configured fallback when the optional engine is not installed.
            return fallback unless engine_module

            # Resolve the configured class directly inside the engine module.
            service_class = engine_module.const_get(@service_name, false)

            # Instantiate the class with the arguments previously stored by `from`.
            service = service_class.new(*@service_args, **@service_kwargs)

            # Invoke the public method configured by `call` and return its result.
            service.public_send(@method_name, *@method_args, **@method_kwargs)
        rescue StandardError => error
            # Re-raise by default so integration and implementation errors remain visible.
            raise unless @fallback_on_error

            # Record handled errors without interrupting the caller's execution.
            Rails.error.report(
                error,
                handled: true,
                context: {
                    module_name: @module_name,
                    service_name: @service_name,
                    method_name: @method_name
                }
            )

            # Allow optional integrations to fail without breaking the calling feature.
            fallback
        end

        attr_reader :fallback

        def resolve_constant(namespace, constant_name)
            return unless namespace.const_defined?(constant_name, false)

            namespace.const_get(constant_name, false)
        end
    end
end
