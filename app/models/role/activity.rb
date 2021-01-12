=begin
    
Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
  
=end
class Role::Activity < ApplicationRecord
    belongs_to :role,           foreign_key: "roles_id"
    belongs_to :user_creator,   foreign_key: "users_id", class_name: "::User", optional: true

    enum category: {
        action_create:                          "action_create",
        action_show:                            "action_show",
        action_update:                          "action_update",
        action_destroy:                         "action_destroy",
        action_update_role_privilege:           "action_update_role_privilege",
        action_create_role_privilege:           "action_create_role_privilege"
    }

    def self.options(current_user, query)
        return {
            categories: self.categories.map {|k, _| {value: k, text: k}},
        }
    end

    def self.index(role, query)
        activities = role
                    .activities
                    .select(
                        "role_activities.id",
                        "role_activities.description", 
                        "role_activities.value_from",
                        "role_activities.value_to",
                        "role_activities.field_name",
                        "role_activities.category",         
                        "concat(user_details.first_name, ' ', user_details.last_name) as user_creator_name",
                        "#{LC::Date.db_to_char("role_activities.created_at", "created_at_raw")}",
                        "role_activities.created_at as created_at"
                    )
                    .where("role_activities.category not in (?)", [
                            "action_show"
                        ]
                    )
                    .joins(user_creator: [:detail])

        query_text = query[:filters][:text].downcase

        activities = activities.where("
            lower(role_activities.description) similar to '%#{query_text}%' or  
            lower(user_details.first_name) similar to '%#{query_text}%' or 
            lower(user_details.last_name) similar to '%#{query_text}%'
        ") if not query_text.blank?  

        activities = activities.where("
            role_activities.category = ?", query[:filters][:text_category]
        ) if not (query[:filters][:text_category]).blank?

        activities = activities.page(query[:pagination][:page])
        .per(query[:pagination][:perPage])
        .order("#{query[:pagination][:orderColumn]} #{query[:pagination][:order]} NULLS LAST")

        acitvities_count = activities.total_count

        activities = activities.map do |activity|  
            {
                id: activity["id"],
                created_at_raw: activity["created_at_raw"],
                description: activity["description"],
                value_from: self.translate_activity_value(activity["value_from"], activity["category"], activity["field_name"]),
                value_to: self.translate_activity_value(activity["value_to"], activity["category"], activity["field_name"]),
                category: self.translate_activity_category(activity["category"]),
                field_name: self.translate_activity_field(activity["field_name"], activity["category"], activity["description"]),
                user_creator_name: activity["user_creator_name"]
            }
        end

        return {
            activities_count: acitvities_count,
            activities: activities
        }
    end 

    def self.translate_activity_field(field_name, category, description)
        return "" if field_name.blank? 

        if (category == "action_create_role_privilege" || category == "action_update_role_privilege")
            return I18n.t("core.roles.view_text_#{field_name}", default: field_name)
        else
            return I18n.t("core.roles.column_#{field_name}", default: field_name)
        end
    end

    def self.translate_activity_value(value, category, field_name)
        return "" if value.blank? 

        if (category == "action_create_role_privilege" || category == "action_update_role_privilege")
            return I18n.t("core.roles.view_text_enabled") if value == "t"

            return I18n.t("core.roles.view_text_disabled") 
        else
            case field_name
            when "object_level_permission"
                value = "max" if value == "2147483647"

                return I18n.t("core.roles.view_text_object_level_permission_#{value}_description")
            else 
                return value
            end
        end
    end

    def self.translate_activity_category(category)
        new_category = I18n.t("core.roles.column_enum_category_#{category}", default: new_category)
        
        new_category
    end
end
