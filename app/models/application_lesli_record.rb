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

class ApplicationLesliRecord < ApplicationRecord

    self.abstract_class = true

    acts_as_paranoid

    # before_validation :custom_validations

    # Low level cache key builder
    def user_cache_key key, current_user:nil, account:nil
        return 'user' << current_user.id.to_s <<  key if current_user
        return 'account' << account.id.to_s  << key if account
        return nil
    end

    # @description Run user defined validations over database columns
    def custom_validations

        module_info = self.class.name.split("::")

        return unless Object.const_defined?("#{module_info[0]}::CustomValidation::Field")

        custom_validation_fields_model= "#{module_info[0]}::CustomValidation::Field".constantize

        fields_to_validate = custom_validation_fields_model.where(
            :model_to_validate => self.class.name,
            #:model_to_validate => self.table_name,
            :column_to_validate => self.class.column_names
        ).to_a

        fields_to_validate.each do |field|
            if field.validation.rule.rule_required
                if self[field.column_to_validate].blank?
                    errors.add(field.column_to_validate, field.validation.rule.rule_required_error_msg)
                end
            end
        end

    end

=begin
@return [Boolean]
@param fields_list [Array] The list of the fields to delete
@description Set all fields to nil excluding foreign key ids
@example
    company_details = CloudHouse::Company.first.detail
    puts company_details #will display an instance of the object
    {
        "id": 1,
        "users_id": 512,
        "name": "Company 1",
        "company_type": "Bank"
    }
    company_details.clear_fields
    puts company_details.clear_fields
    {
        "id": 1,
        "users_id": 512,
        "name": nil,
        "company_type": nil
    }
=end
    def clear_fields(fields_list = nil)
        attributes_hash = {}
        self.attributes.keys.each do |key|
            if key != "id" &&
                key != "created_at" &&
                key != "updated_at" &&
                key != "deleted_at" &&
                !(key.include? "_id")
                    unless fields_list.nil?
                        if (fields_list.include?(key))
                            attributes_hash["#{key}"] = nil
                        end
                    else
                        attributes_hash["#{key}"] = nil
                    end
            end
        end

        self.attributes = attributes_hash
        self.save(validate: false)
    end

    # @return [String] The name of this class, starting with 'Cloud'
    # @description Returns the Lesli engine and class name associated to this model. This method must be overwritten
    #   if you create a new engine that inherits from another Lesli engine (like DeutscheLeibrenten previously CloudHaus)
    # @example
    #   puts CloudHouse::Project.lesli_classname # Will diplay 'CloudHouse::Project'
    #   puts DeutscheLeibrenten::Project.lesli_classname # Will also diplay 'CloudHouse::Project'
    def self.lesli_classname
        return self.name
    end

    # @return [Integer] The threshold value when an user olp priviliges change from '>' to '>='
    # @description The return value indicates an administrator olp threhold (if any). This number indicates
    #   when the condition for editing values should be changed from '>' to '>='
    # @example
    #   # Imagine 5 users:
    #   # 'user_a' has an object_level_permission of 10
    #   # 'user_b' has an object_level_permission of 10
    #   # 'user_c' has an object_level_permission of 100
    #   # 'user_d' has an object_level_permission of 1000
    #   # 'user_e' has an object_level_permission of 1000
    #   olp_threshold = current_user.account.object_level_permission_threshold
    #   puts olb_threshold # This will display 1000
    #   # This means the following
    #   # user_a cannot update user_b olp objects because their olp is the same and lower than the threshold
    #   # user_c can update user_b and user_a olp objects because their olp is higher than theirs
    #   # user_d can update_user_c and, by implication, user_b and user_a olp objects beucase their olp is higher than theirs
    #   # user_e can do the same as user d
    #   # user_e can also update user_d olp objects (and vice versa) because, even though their olp is the same, it is also the same or higher
    #   # than the olb_threshold, and thus, the condition should change from '>' to '>='
    def object_level_permission_threshold
        return 1000
    end

    # @return [Boolean] Whether the user sent as argument can edit this object or not
    # @param current_user [User] The user that wants to edit the resource
    # @description Returns if current_user can edit this resource. A user can edit it if one of the following conditions is met:
    #       - The user is a relevant resource user (see relevant_users method)
    #       - The user's object_level_permission is greater or equal than the object_level_permission threshold, and greater or equal than the object_level_permission of the creator
    def is_editable_by?(current_user)
        return false unless current_user

        if current_user == user_creator 
            return true
        end

        if defined? (user_main)
            return true if current_user == user_main
        end

        current_user_olp = User
            .joins(:roles)
            .where("users.id = ?", current_user.id)
            .select("roles.object_level_permission")
            .first.object_level_permission

        reference_olp = 0
        if user_creator
            reference_olp = user_creator.roles.first&.object_level_permission || 0
        elsif user_main
            reference_olp = user_main.roles.first&.object_level_permission || 0
        end

        if current_user_olp >= object_level_permission_threshold && current_user_olp >= reference_olp
            return true
        end

        return false
    end

end
