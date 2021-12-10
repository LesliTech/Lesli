# Safe method to re-enable the GET method due the new CSFR protection in OmniAuth
OmniAuth.config.allowed_request_methods = %i[get]
