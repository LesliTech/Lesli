
# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
Rails.application.config.assets.precompile += %w( cloud_lesli/*.css )
Rails.application.config.assets.precompile += %w( websites/landing.css )
Rails.application.config.assets.precompile += %w( users/*.css users/**/*.css )
