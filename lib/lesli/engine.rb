=begin
=end

module Lesli
    class Engine < ::Rails::Engine
        isolate_namespace Lesli

        # register engine migrations path
        initializer :lesli do |app|

            # register assets manifest
            config.assets.precompile += %w( lesli_manifest.js )

            # Include lib/assets folder in the asset pipeline
            config.assets.paths << root.join("lib", "assets")

            config.assets.paths << root.join("lib", "sass")

            # Include third-party assets
            config.assets.paths << root.join("vendor")

            # Automatic load migrations from Lesli
            unless app.root.to_s.match root.to_s
                config.paths["db/migrate"].expanded.each do |expanded_path|
                    app.config.paths["db/migrate"] << expanded_path
                end
            end
        end
    end
end
