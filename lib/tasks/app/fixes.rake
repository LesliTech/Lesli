namespace :app do
    namespace :fixes do
        desc "Create default role descriptors"
        task default_role_descriptors: :environment do
            company_name = Rails.application.config.lesli_settings["account"]["company"]["name"]
            account = Account.find_by(company_name: company_name)
            
            owner_descriptor = account.role_descriptors.find_or_create_by(name: "owner")
            owner_role = account.roles.find_by(name: "owner")
            owner_role.descriptor_assignments.find_or_create_by!(descriptor: owner_descriptor)
            
            old_admin_descriptor = account.role_descriptors.find_by(name: "admin")
            old_admin_descriptor.update(name: "sysadmin") if old_admin_descriptor.present?
            
            admin_descriptor = account.role_descriptors.find_or_create_by(name: "sysadmin")
            admin_role = account.roles.find_by(name: "sysadmin")
            admin_role.descriptor_assignments.find_or_create_by!(descriptor: admin_descriptor)
            
            puts "FINISH"
        end

        desc "Fix schema migration"
        task schema_migration: :environment do
=begin
BASED ON
50 -> 00.38. access codes
40 -> 00.60. templates 
41 -> 00.61. template_documents
42 -> 00.62. template_variables
43 -> 00.63. template_mappings
44 -> 00.64. template_audience_document
60 -> 00.70  invites
24 -> 00.55  role activities 

DELETED MIGRATIONS 
00000021_create_role_privileges
00000022_create_role_overrides.rb


NEW MIGRATIONS
00.55. roles (reference only)
00.56. role_descriptors
00.57. role_activities
=end

            ActiveRecord::Base.connection.exec_query("
                DELETE
                FROM schema_migrations
                WHERE version = '50' or
                    version = '40' or
                    version = '41' or
                    version = '42' or
                    version = '43' or
                    version = '44' or
                    version = '21' or
                    version = '22' or 
                    version = '23' or 
                    version = '24' or 
                    version = '51' or 
                    version = '30'
                ;
            ")
            
            ActiveRecord::Base.connection.exec_query("
                INSERT INTO schema_migrations (version) VALUES ('37');
            ")
        
            ActiveRecord::Base.connection.exec_query("
                INSERT INTO schema_migrations (version) VALUES ('38');
            ")
            
            ActiveRecord::Base.connection.exec_query("
                INSERT INTO schema_migrations (version) VALUES ('61');
            ")
            
            ActiveRecord::Base.connection.exec_query("
                INSERT INTO schema_migrations (version) VALUES ('62');
            ")
            
            ActiveRecord::Base.connection.exec_query("
                INSERT INTO schema_migrations (version) VALUES ('63');
            ")
            
            ActiveRecord::Base.connection.exec_query("
                INSERT INTO schema_migrations (version) VALUES ('64');
            ")
            
            ActiveRecord::Base.connection.exec_query("
                INSERT INTO schema_migrations (version) VALUES ('57');
            ")
            
            ActiveRecord::Base.connection.exec_query("
                INSERT INTO schema_migrations (version) VALUES ('70');
            ")
        
            puts "---------- FINISH ----------"
        end
    end
end
