
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('vendor')

# Precompile additional assets.
Rails.application.config.assets.precompile += %w( websites.css )
Rails.application.config.assets.precompile += %w( accounts.css )
Rails.application.config.assets.precompile += %w( users/*.css users/**/*.css )
Rails.application.config.assets.precompile += %w( cloud_driver/*.css )
Rails.application.config.assets.precompile += %w( cloud_lesli/*.css )
Rails.application.config.assets.precompile += %w( cloud_books/*.css )
Rails.application.config.assets.precompile += %w( cloud_panel/*.css )
Rails.application.config.assets.precompile += %w( cloud_team/*.css )
Rails.application.config.assets.precompile += %w( cloud_bell/*.css )
Rails.application.config.assets.precompile += %w( cloud_help/*.css )
Rails.application.config.assets.precompile += %w( cloud_lock/*.css )
Rails.application.config.assets.precompile += %w( cloud_kb/*.css )


Rails.application.config.assets.precompile += %w( i18n.js )
Rails.application.config.assets.precompile += %w( websites_landing.js )
Rails.application.config.assets.precompile += %w( cloud_driver/*.js )
Rails.application.config.assets.precompile += %w( cloud_lesli/*.js )
Rails.application.config.assets.precompile += %w( cloud_books/*.js )
Rails.application.config.assets.precompile += %w( cloud_panel/*.js )
Rails.application.config.assets.precompile += %w( cloud_team/*.js )
Rails.application.config.assets.precompile += %w( cloud_bell/*.js )
Rails.application.config.assets.precompile += %w( cloud_help/*.js )
Rails.application.config.assets.precompile += %w( cloud_lock/*.js )
Rails.application.config.assets.precompile += %w( cloud_kb/*.js )
