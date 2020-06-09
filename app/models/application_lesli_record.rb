=begin
    
Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
    
=end

class ApplicationLesliRecord < ApplicationRecord
    self.abstract_class = true

    acts_as_paranoid

    # before_validation :custom_validations

    # @description Run user defined validations over database columns
    def custom_validations

        module_info = self.class.name.split("::")

        return if not Object.const_defined?("#{module_info[0]}::CustomValidation::Field")

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
    def clear_fields
        attributes_hash = {}
        self.attributes.keys.each do |key|
            if key != "id" && 
                key != "created_at" && 
                key != "updated_at" && 
                key != "deleted_at" && 
                !(key.include? "_id")
                    attributes_hash["#{key}"] = nil
            end
        end

        self.attributes = attributes_hash
        self.save(validate: false)
    end
end
