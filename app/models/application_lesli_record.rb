class ApplicationLesliRecord < ApplicationRecord
    self.abstract_class = true

    before_validation :custom_validation_rules

    def custom_validation_rules

        validations = CloudFocus::CustomValidation.first
        .validation_rule
        .validation_fields.where(
            :model_to_validate => self.class.name,
            :column_to_validate => CloudFocus::Task::Detail.column_names
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
