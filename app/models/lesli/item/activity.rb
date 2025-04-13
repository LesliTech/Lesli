module Lesli
    module Item
        class Activity < ApplicationRecord

            def self.table_name
                return @cached_table_name if defined?(@cached_table_name) && @cached_table_name

                engine = infer_engine_from_namespace
                raise "Could not infer engine name for activity table" unless engine

                @cached_table_name = "#{engine}_user_activities"
            end

            def self.infer_engine_from_namespace

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
                end
                nil
            end
        end
    end
end
