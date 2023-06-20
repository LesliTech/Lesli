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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end
class Profile::Subscription < ApplicationLesliRecord

    def self.index(current_user, query)
        subscriptions = []

        return [] unless query[:filters]["engine"]

        # We retrieve all tables that have the following naming pattern: "engine_MODEL_subscribers"
        engine = query[:filters]["engine"]

        tables = ActiveRecord::Base.connection.tables.grep(/^#{engine}.+_subscribers$/)

        # We turn those table names into actual classes
        subscriber_classes = tables.map do |table|
            table.sub("#{engine}_", "#{engine}/").sub("_subscribers", "/subscriber").classify

        end

        # We format the data and return it
        subscriber_classes.each do |subscriber_class|
            subscriptions_data = subscriber_class.constantize.where(user_creator: current_user).order(id: :desc).all.filter_map do |subscriber|
                if subscriber.cloud_object
                    cloud_object = subscriber.cloud_object
                    cloud_object_table = subscriber.class.reflect_on_association(:cloud_object).table_name
                    engine_url = "#{engine.classify}::Engine".constantize.routes.find_script_name({})

                    action = I18n.t(
                        "core.shared.column_enum_subscriptions_action_#{subscriber.action}",
                        default: I18n.t(
                            "#{cloud_object.class.name.underscore.gsub("cloud_", "").sub("/", ".")}/subscribers.column_enum_action#{subscriber.action}",
                            default: subscriber.action
                        )
                    )

                    {
                        id: subscriber.id,
                        action: action,
                        notification_type: subscriber.notification_type,
                        cloud_object_id: subscriber["#{cloud_object_table.pluralize}_id"],
                        cloud_object_global_identifier: cloud_object.global_identifier,
                        cloud_object_type: I18n.t("#{cloud_object.class.name.underscore.pluralize.gsub("cloud_", "").sub("/", ".")}.view_title_main"),
                        resource_url: engine_url,
                        resource_urn: "/#{cloud_object_table.sub("#{engine}_", "")}/#{cloud_object.url_identifier}",
                        url: "#{engine_url}/#{cloud_object_table.sub("#{engine}_", "")}/#{cloud_object.id}/subscribers/#{subscriber.id}",
                        subscriber_key: "#{cloud_object.class.name.underscore.gsub("#{engine}/", "").downcase}_subscriber"
                    }
                else
                    nil
                end
            end

            subscriptions.concat(subscriptions_data)
        end

        subscriptions
    end

    def self.options(current_user, query)
        engines = []
        Rails.application.config.lesli.dig(:engines).map do |engine|
            if(engine)
                engines.append({
                    value: engine[:name],
                    text: engine[:code]
                })
            end
        end
        {
            engines: engines,
            notification_types: CloudObject::Subscriber.notification_types
        }
    end
end
