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

# · 
module Lesli 
    class ApplicationLesliService
        attr_reader :current_user, :query, :errors

        # Services receive their request context explicitly. A system operation
        # without an authenticated user must pass nil intentionally.
        def initialize(current_user, query = {})
            @current_user = current_user
            @query = query
            @resource = nil
            @errors = []
        end

        # Store the result of an account-scoped lookup and return the service so
        # controllers can inspect found? and result through one contract.
        def find(resource)
            self.resource = resource
            self
        end

        def found?
            !resource.nil?
        end

        def successful?
            errors.empty?
        end

        def errors_as_sentence
            errors.to_sentence
        end

        def result
            resource
        end

        def cache_key_for_account(method = nil)
            cache_key_builder("account", current_user.account.id, method)
        end

        def cache_key_for_user(method = nil)
            cache_key_builder("user", current_user.id, method)
        end

        protected

        attr_reader :resource
        attr_writer :resource

        # Store the result of a mutation and preserve the service response
        # contract used by controllers.
        def response(resource)
            self.resource = resource
            self
        end

        def error(message)
            errors << message
        end

        private

        def cache_key_builder(namespace, namespace_id, method)
            [
                namespace,
                namespace_id,
                self.class.name.underscore,
                method,
                query[:cacheKey]
            ].compact.join(":").tr("/_", "-")
        end
    end
end
