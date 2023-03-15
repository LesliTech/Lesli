
Aws.config.update({
    region: Rails.application.credentials.dig(:providers, :aws, :region),
    access_key_id: Rails.application.credentials.dig(:providers, :aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:providers, :aws, :secret_access_key)
})

if Rails.configuration.lesli.dig(:env, :action_mailer, :delivery_method) == "ses"
    Aws::Rails.add_action_mailer_delivery_method(:ses,
        credentials: Aws::Credentials.new(    
            Rails.application.credentials.dig(:providers, :aws, :ses, :access_key_id),
            Rails.application.credentials.dig(:providers, :aws, :ses, :secret_access_key)
        )
    )
end
