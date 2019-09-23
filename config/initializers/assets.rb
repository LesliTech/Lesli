
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
Rails.application.config.assets.precompile += %w( websites/*.css )
Rails.application.config.assets.precompile += %w( accounts.css )
Rails.application.config.assets.precompile += %w( users/*.css users/**/*.css )
Rails.application.config.assets.precompile += %w( cloud_lesli/*.css  )
Rails.application.config.assets.precompile += %w( cloud_team/*.css )
Rails.application.config.assets.precompile += %w( cloud_dev/*.css )
Rails.application.config.assets.precompile += %w( cloud_wiki/**/*.css )

Rails.application.config.assets.precompile += %w( lesli.js )
Rails.application.config.assets.precompile += %w( i18n.js )
Rails.application.config.assets.precompile += %w( cloud_team/*.js cloud_team/**/*.js )
Rails.application.config.assets.precompile += %w( cloud_lesli/*.js cloud_lesli/**/*.js )
