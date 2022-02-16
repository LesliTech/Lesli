Sentry.init do |config|
    config.dsn = 'https://3eec1bf3662b4108a7f87df3758b4889@o1144649.ingest.sentry.io/6208827'
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set tracesSampleRate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production
    config.traces_sample_rate = 1.0
    # or
    config.traces_sampler = lambda do |context|
        true
    end
end
