class ApplicationJob < ActiveJob::Base
    # Automatically retry jobs that encountered a deadlock
    # retry_on ActiveRecord::Deadlocked

    # Most jobs are safe to ignore if the underlying records are no longer available
    # discard_on ActiveJob::DeserializationError

    # Track specific account activity
    # this is disabled by default in the settings file
    def log_account_activity system_module, system_process, description=nil, payload=nil

        return if !Rails.application.config.lesli_settings["configuration"]["security"]["log_activity"]

        Account.first.activities.create({
            system_module: system_module,
            system_process: system_process,
            description: description,
            payload: payload
        })

    end

end
