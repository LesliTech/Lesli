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

    before_validation :custom_validations

    def custom_validations

        puts "~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~"
        puts "~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~"
        puts "~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~"
        puts "~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~"
        puts "~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~     ~"

        module_info = self.class.name.split("::")

        return if not Object.const_defined?("#{module_info[0]}::CustomValidation")

        custom_validation_model= "#{module_info[0]}::CustomValidation".constantize 

        validations = custom_validation_model.first

        return if validations.blank?

        validations.validation_rule
        .validation_fields.where(
            :model_to_validate => self.class.name,
            :column_to_validate => self.class.column_names
        ).to_a

        validations.each do |validation|
            if validation.rule.rule_required
                if self[validation.column_to_validate].blank?
                    errors.add(validation.column_to_validate, validation.rule.message_error)
                end
            end
        end

    end

end
