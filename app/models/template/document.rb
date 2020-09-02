class Template::Document < ApplicationLesliRecord
    belongs_to :template, foreign_key: "templates_id"
    has_many :mappings, foreign_key: "template_documents_id", dependent: :destroy 

    enum template_types: {
        
    }

    def self.s3_client
        return( 
            Aws::S3::Client.new(
                region: Rails.application.credentials.s3[:region],
                access_key_id: Rails.application.credentials.s3[:access_key_id], 
                secret_access_key: Rails.application.credentials.s3[:secret_access_key], 
            )
        )
    end

    def self.s3_bucket
        return ( 
            Aws::S3::Resource.new(
                region: Rails.application.credentials.s3[:region],
                access_key_id: Rails.application.credentials.s3[:access_key_id], 
                secret_access_key: Rails.application.credentials.s3[:secret_access_key], 
            ).bucket(Rails.application.credentials.s3[:bucket])
        )
    end

    private

    def self.scan_variables(current_user, template_document, variables)
        variables.each do |variable_name|
            variable_name = variable_name.gsub("$$", "")
            current_user.account.template.variables.each do |variable|
                if (variable.name == variable_name)
                    template_document.mappings.find_or_create_by(template_variables_id: variable.id)
                    next
                end
            end
        end
    end

    def self.scan_table_fields(table_name, fields)
        # puts table_name
        # if fields[table_name].nil? 
        #     fields[table_name] = []

        #     columns = ActiveRecord::Base.connection.columns(table_name)
        #     columns.map do |column|
        #         column_name = column.name 

        #         if column_name != "id" && 
        #             column_name != "created_at" && 
        #             column_name != "updated_at" && 
        #             column_name != "deleted_at" && 
        #             !(column_name.include? "accounts_id")

                    
        #             if (column_name.include? "_id")
        #                 column_name = column_name.gsub("_id", "")
                        
        #                 if (column_name == "user_main" || column_name == "user_creator" ||column_name == "reviewer_employee")
        #                     column_name = "users"
        #                 elsif (column_name == "location_state" || column_name == "location_city")
        #                     column_name = "account_locations"
        #                 elsif (column_name == "parent")
        #                     next
        #                 end

                        # Template::Document.scan_table_fields(column_name, fields)
        #             else
        #                 fields[table_name].push(column_name)
        #             end
        #         end
        #     end
        # end
    end
end
