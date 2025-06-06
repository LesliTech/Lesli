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

module MigrationHelpers
    module Common

        def table_name_for_shared(engine, table_name)
            table_name = "#{engine}_#{table_name}".to_sym
            table_name_account = "#{engine}_accounts".to_sym

            return [table_name, table_name_account]
        end

        def table_name_for_item(resources, item)

            engine = infer_engine_from_namespace

            resource = resources.to_s.singularize
            table_name = "#{resource}_#{item}".to_sym
            foreign_key = resource.sub("#{engine}_","")

            return [table_name, foreign_key]
        end

        def infer_engine_from_namespace

            caller_locations(3, 10).each do |loc|
                path = loc.absolute_path || loc.path

                # Try matching standard gem folder path (e.g., gems/lesli_shield-0.1.0)
                if path =~ %r{/gems/(lesli_[^/-]+)}
                    return $1
                end

                # Try matching from engines folder in dev
                if path =~ %r{/engines/(lesli_[^/]+)}
                    return $1
                end

                # Local installed engines
                if path =~ %r{/engines/(Lesli[^/]+)}
                    return $1.underscore
                end

                # workaround to let Lesli core use items

                # Try matching standard gem folder path (e.g., gems/lesli_shield-0.1.0)
                if path =~ %r{/gems/(lesli)}
                    return $1
                end

                # Try matching from engines folder in dev
                if path =~ %r{/engines/(lesli)}
                    return $1
                end

                # Local installed engines
                if path =~ %r{/engines/(Lesli)}
                    return $1.underscore
                end
            end
            nil
        end
    end
end
