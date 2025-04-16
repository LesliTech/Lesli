
module MigrationHelpers
    module Common
        def table_names_for_shared(engine, table_name)
            table_name = "#{engine}_#{table_name}".to_sym
            table_name_account = "#{engine}_accounts".to_sym

            return [table_name, table_name_account]
        end

        def table_names_for_item(resources, item)

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
            end
            nil
        end
    end
end
