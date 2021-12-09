
Rails.application.config.middleware.use OmniAuth::Builder do
    provider :google_oauth2, Rails.application.credentials.dig(:providers, :google, :client_id), Rails.application.credentials.dig(:providers, :google, :client_secret) #, provider_ignores_state: Rails.env.development?
end

OmniAuth.config.allowed_request_methods = %i[get]

# OmniAuth.config.full_host = Rails.env.production? ? 'https://domain.com' : 'http://localhost:3000'
