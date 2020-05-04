class ApplicationLesliRecord < ApplicationRecord
    self.abstract_class = true

    before_validation :custom_validation_rules

    def custom_validation_rules

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
