class ApplicationLesliRecord < ApplicationRecord
    self.abstract_class = true

    before_validation :custom_validation_rules

    def custom_validation_rules
        dynamic_validation_info = self.class.dynamic_validation_info
        custom_validation_model = dynamic_validation_info[:custom_validation_model]

        validations = custom_validation_model.first
        .validation_rule
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

        # @return [Hash] Hash that contains information about the class
        # @description Returns dynamic information based on the current implementation of this abstract class
        # @example
        #     dynamic_validation_info = CloudHelp::Ticket::Detail.dynamic_validation_info
        #     puts dynamic_validation_info[:custom_validation_model].new # will print a new instance of CloudHelp::CustomValidation
        def self.dynamic_validation_info
            module_info = self.name.split("::")
            {
                custom_validation_model: "#{module_info[0]}::CustomValidation".constantize
            }
        end

end
