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

    revision = LC::System::Info.revision()
    engines = Lesli::engines.map { |engine| { 
        :engine => engine[:code], :version => "#{engine[:version]} (#{engine[:type]})" 
    }}

    LC::Debug.separator_blank(3)
    LC::Debug.msgc(
        'Instance: ' << Rails.application.config.lesli[:instance][:name],
        'Version: ' << revision[:version],
        'Build: ' << revision[:build]
    )

    LC::Debug.separator_blank
    LC::Debug.table (engines)
    LC::Debug.separator_blank(2)

    if (Rails.application.config.lesli.dig(:security, :version) === 4)
    LC::Debug.info("Roles & privileges version 4 is enabled, check & map your controllers to make it work properly")
    LC::Debug.separator_blank(2)
    end

end
