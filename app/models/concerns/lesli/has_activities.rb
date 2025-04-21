
module Lesli
    module HasActivities
        extend ActiveSupport::Concern

        class_methods do
            def has_activities_with(custom_table_name)
                has_many :activities, class_name: "Lesli::Item::Activity"

                Lesli::Item::Activity.class_eval do
                    self.table_name = custom_table_name.to_s
                end
            end

            # thread safe - does not work yet
            def has_activities_with2(custom_table_name)

                # Define a unique class name per model using the model's namespace
                klass = Class.new(Lesli::Item::Activity) do
                    self.table_name = custom_table_name
                end

                const_set("LocalActivity", klass)

                has_many :activities, class_name: "#{self.name}::LocalActivity"
            end
        end
    end
end
