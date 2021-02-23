# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do

    errors = []
    warns = []

    # Essentials
    errors.push("Error with database credentials") if !Rails.application.credentials.config.has_key?(:db)
    errors.push("Error with database credentials") if !Rails.application.credentials.db.has_key?(:database)
    errors.push("Error with database credentials") if !Rails.application.credentials.db.has_key?(:username)
    errors.push("Error with database credentials") if !Rails.application.credentials.db.has_key?(:password)

    if errors.size > 0
        LC::Debug.fatal(*errors);  exit; 
    end

    optionals = {
        services: {
            jwt: { secret: "" }
        },
        providers: {
            aws: {
                region: "",
                access_key_id: "",
                secret_access_key: "",
                s3: {
                    bucket: "",
                    access_key_id: "",
                    secret_access_key: ""
                },
                ses: {
                    access_key_id: "",
                    secret_access_key: ""
                },
                sns: {
                    access_key_id: "",
                    secret_access_key: ""
                }
            },
            google: {
                maps_sdk_token: "",
                firebase: {
                    api_key: "",
                    admin_sdk_private_key: {
                        type: "",
                        project_id: "",
                        private_key_id: "",
                        private_key: "",
                        client_email: "",
                        client_id: "",
                        auth_uri: "",
                        token_uri: "",
                        auth_provider_x509_cert_url: "",
                        client_x509_cert_url: ""
                    },
                    web: {
                        apiKey: "",
                        authDomain: "",
                        projectId: "",
                        storageBucket: "",
                        messagingSenderId: "",
                        appId: ""
                    }
                }
            },
            honey_badger: {
                api_key: "",
                personal_token: ""
            }
        }
    }

    def compare(a, b, warns, ref="")

        a.each_with_object([]) do |(k,v)|

            if !b.has_key?(k)
                warns.push("Credential entry for  #{k} not found") 
                next;
            end

            if b[k].blank?
                warns.push("Credential entry found but empty for: #{k}") 
            end

            warns = compare(v, b[k], warns, ref) if v.is_a? Hash

        end

        warns

    end

    warns = compare(optionals, Rails.application.credentials.config, warns)
    
    LC::Debug.warn(*warns, "Some services may not work as spected.")
    
    puts ""; puts ""; puts "";
    puts "Loading installed engines: "
    puts '---     ---     ---     ---     ---'
    Lesli::engines.each do |engine|
    puts "- #{engine[:code]} #{engine[:version]} (#{engine[:type]})"
    end
    puts ""; puts "";

end
