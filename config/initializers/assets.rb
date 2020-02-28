
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '0.1.0'

# Add additional assets to the asset load path.
#Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('vendor')

# Precompile additional assets.

Rails.application.config.assets.precompile += %w(themes/blank.css)
Rails.application.config.assets.precompile += %w(themes/**/standard/*.css)

Rails.application.config.assets.precompile += %w( users/*.css )
Rails.application.config.assets.precompile += %w( websites.css )
Rails.application.config.assets.precompile += %w( accounts.css )
Rails.application.config.assets.precompile += %w( dashboards.css )

Rails.application.config.assets.precompile += %w( users/*.js )
Rails.application.config.assets.precompile += %w( websites/*.js )
Rails.application.config.assets.precompile += %w( accounts/app.js )
Rails.application.config.assets.precompile += %w( dashboards/app.js )
Rails.application.config.assets.precompile += %w( i18n.js )

if defined?(CloudHaus)
    Rails.application.config.assets.precompile += %w( cloud_haus/*.js )
    Rails.application.config.assets.precompile += %w( cloud_haus/*.css )
    Rails.application.config.assets.precompile += %w( cloud_haus/**/*.png cloud_haus/**/*.svg )
end

if defined?(CloudDriver)
    Rails.application.config.assets.precompile += %w( cloud_driver/*.js )
    Rails.application.config.assets.precompile += %w( cloud_driver/*.css )
end

if defined?(CloudFocus)
    Rails.application.config.assets.precompile += %w( cloud_focus/*.js )
    Rails.application.config.assets.precompile += %w( cloud_focus/*.css )
end

=begin

Rails.application.config.assets.precompile += %w( cloud_kb/*.css )
Rails.application.config.assets.precompile += %w( cloud_bell/*.css )
Rails.application.config.assets.precompile += %w( cloud_lock/*.css )
Rails.application.config.assets.precompile += %w( cloud_team/*.css )
Rails.application.config.assets.precompile += %w( cloud_help/*.css )
Rails.application.config.assets.precompile += %w( cloud_house/*.css )
Rails.application.config.assets.precompile += %w( cloud_lesli/*.css )
Rails.application.config.assets.precompile += %w( cloud_babel/*.css )

Rails.application.config.assets.precompile += %w( cloud_kb/*.js )
Rails.application.config.assets.precompile += %w( cloud_bell/*.js )
Rails.application.config.assets.precompile += %w( cloud_lock/*.js )
Rails.application.config.assets.precompile += %w( cloud_team/*.js )
Rails.application.config.assets.precompile += %w( cloud_help/*.js )
Rails.application.config.assets.precompile += %w( cloud_house/*.js )
Rails.application.config.assets.precompile += %w( cloud_lesli/*.js )
Rails.application.config.assets.precompile += %w( cloud_babel/*.js )

=end
