module CloudObject
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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Base abstract model for *Workflow* *association* core entity used for workflows

=end
    class Workflow::Association < ApplicationLesliRecord
        self.abstract_class = true

        validates :workflow_for, presence: true

        after_create    :verify_uniqueness

=begin
@return [Array] Array of global associations
@param account [::Account] The account of the user that made this request
@description Returns an array of possible global and specific associations
@example 
    # Imagine we are in CloudHouse, workflows are available for projects, properties, companies,
    # and employees. Imagine that the only non global association is for projects, and it's based on
    # project types, and imagine there are 2 project types.
    association_options = CloudHouse::Workflow::Association.association_options
    puts association_options.to_json # will display something similar to
    #[
    #    {"name":"Property", "workflow_for":"property", "details":[]},
    #    {"name":"Employee", "workflow_for":"employee","details":[]},
    #    {"name":"Company", "workflow_for":"property", "details":[]},
    #    {
    #        "name":"Project",
    #        "workflow_for": "project"
    #        "details":[
    #            {
    #                "name":"project_type",
    #                "list":[
    #                    {
    #                        "id":1,
    #                        "name":"Maintenance"
    #                    },{
    #                        "id":2,
    #                        "name":"Sale"
    #                    }
    #                ]
    #            }
    #        ]
    #    }
    #]
=end
        def self.association_options(account)
            module_name = self.dynamic_info[:module_name]
            associations = []

            self.object_associations.each do |association_key, association_value|
                data = {
                    workflow_for: association_value,
                    name: association_value, # This is the field that must be translated
                    details: []
                }

                details = self.object_association_details(association_value)
                details.each do |detail|
                    if detail[:type] == "foreign_key"
                        detail_list = detail[:class].constantize.where(
                            "cloud_#{module_name}_accounts_id" => account.id
                        ).select(
                            :id,
                            "#{detail[:identifier]} as name"
                        )

                        data[:details].push({
                            field_name: detail[:name],
                            name: detail[:name], # This is the field that must be translated
                            list: detail_list
                        })
                    elsif detail[:type] == "detail_enum"
                        detail_list = detail[:class].constantize.send(detail[:name].pluralize).map do |key, value|
                            {
                                id: key,
                                field_name: detail[:name],
                                name: I18n.t("#{module_name}.#{association_value.pluralize}.enum_#{detail[:name]}_#{value}")
                            }
                        end

                        data[:details].push({
                            field_name: detail[:name],
                            name: detail[:name], # This is the field that must be translated
                            list: detail_list
                        })
                    end
                end

                associations.push(data)
            end

            associations
        end

=begin
@return [Hash] list of associations of this related to the *workflow*
@param workflow [CloudObject::Workflow] The workflow to which the associations are to be shown
@description Selects all the associations and formats them so the user can understand them. If the
    association is not global, goes to the respective table of the detail (specified by the subclass's method
    *object_association_details*) and selects the identifier, to display it to the user if an understandable format.
@example
    # Imagine we are in CloodHouse, and we have 1 workflow associated to projects, companies and properties,
    # and the project association is only to the projects that have th *maintenance* type.
    workflow = CloudHouse::Workflow.find(1)
    puts CloudHouse::Workflow::Asociation.list(workflow).to_json
    # will display something like 
    #[
    #    {
    #        "id":1,
    #        "workflow_for":"Projects",
    #        "global":false,
    #        "details":" Project type: Maintenance"
    #    },{
    #        "id":2,
    #        "workflow_for":"Companies",
    #        "global":true
    #    },{
    #        "id":3,
    #        "workflow_for":"Properties",
    #        "global":true,
    #    }
    #]
=end
        def self.list(workflow)
            module_name = self.dynamic_info[:module_name]

            workflow.associations.map do |association|
                attributes = association.attributes

                attributes["details"] = ""
                
                unless(attributes["global"])
                    details = self.object_association_details(attributes["workflow_for"])

                    details.each do |detail|
                        name_translation = I18n.t("#{module_name}.workflow/associations.enum_association_#{attributes["workflow_for"]}_field_#{detail[:name]}")

                        if detail[:type] == "foreign_key"
                            record = detail[:class].constantize.find_by(
                                id: attributes[detail[:name]],
                                account: workflow.account
                            )
                            value_translation = I18n.t(
                                "#{module_name}.workflow/associations.enum_association_#{attributes["workflow_for"]}_field_#{detail[:name]}_#{record[detail[:identifier]]}",
                                default: record[detail[:identifier]]
                            )


                            attributes["details"] += " #{name_translation}: #{value_translation},"
                        elsif detail[:type] == "detail_enum"
                            enum_value = detail[:class].constantize.send(detail[:name].pluralize)[attributes[detail[:name]]]
                            value_translation = I18n.t("#{module_name}.#{attributes["workflow_for"].pluralize}.enum_#{detail[:name]}_#{enum_value}")
                            
                            attributes["details"] += " #{name_translation}: #{value_translation},"
                        end
                    end

                    attributes["details"].delete_suffix!(",")
                end

                attributes
            end
        end

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    # Imagine the current class is an instance of CloudHelp::Workflow::Association < CloudObject::Workflow::Association
    info = dynamic_info
    puts info[:module_name] # will print 'help'
=end
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")
            module_name = module_info[0].sub("Cloud", "").downcase

            {
                module_name: module_name
            }
        end

        protected

=begin
@return [Array] Array of hashes, each hash contains information about the association detail of this workflow
    (like class, primary key, identifier, etc.)
@param association_name [String] The name of the association
@description A workflow can be associated to a specific class, based on certain field. For example, one workflow can be
    assigned to purchase projects, and another workflow can be assigned to sale projects. This method returns the details
    to create that specific association
@example
    # Imagine you want to associate a workflow to a project based on it's type, then you should execute
    association_details = Workflow::Association.object_association_details('project')
    puts association_details.to_json # Will display something like
    # [{
    #     "name": "project_type",
    #     "class": "CloudHouse::Catalog::ProjectType",
    #     "key": :"cloud_house_catalog_project_types_id",
    #     "identifier": :"name"
    # }]
    # Where "name" is the name of the association detail, class is the Rails class of the model, key is the primary key of that table,
    # and identifier is a field, in that table, that allows the user to identify one entry from the other. In this example "name" will have
    # values like "sale", "purchase", "repair", etc.
=end
        def self.object_association_details(association_name)
            return []
        end

        
=begin
@return [void]
@description Checks the workflow associations table for entries that have the exact same association
    and deletes them. This is an *after_create* action and should not be called manually
@example
    workflow = CloudHouse::Workflow.find(1)
    workflow.associations.create(workflow_for: 'project', global: true)
    workflow.associations.create(workflow_for: 'project', global: true) # When this association is created, the old
    # will be deleted
=end
        def verify_uniqueness
            dynamic_info = self.class.dynamic_info
            module_name = dynamic_info[:module_name]

            unique_attributes = attributes.to_hash
            unique_attributes.except!("id", "created_at", "updated_at", "cloud_#{module_name}_workflows_id")

            dupplicated_associations = self.class.joins(
                :workflow
            ).where(
                unique_attributes
            ).where(
                "cloud_#{module_name}_workflows.cloud_#{module_name}_accounts_id = #{workflow.account.id}"
            ).where.not(
                id: id
            )

            unless dupplicated_associations.empty?
                dupplicated_associations.destroy_all
            end
        end
    end
end
    