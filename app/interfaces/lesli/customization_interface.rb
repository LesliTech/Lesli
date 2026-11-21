module Lesli
    module CustomizationInterface

        # Load the account theme for pages rendered by the shared application layout.
        def set_customizer
            # Turbo redirects can negotiate HTML through the Turbo Stream MIME type.
            return unless request.format.html? || request.format.pdf?
            return unless defined?(LesliAdmin) && respond_to?(:current_user, true) && current_user

            color = Lesli::Courier.new(:lesli_admin)
                .from(:theme_operator, current_user)
                .call(:primary_color)

            # Only emit a hex color. Missing or invalid settings keep the CSS fallback.
            return unless color.to_s.match?(/\A#(?:\h{3}|\h{6})\z/)

            @lesli[:customization] ||= {}
            @lesli[:customization][:colors] ||= {}
            @lesli[:customization][:colors][:lesli_theme_color_primary] = color
        end
    end
end
