Lesli.configure do |config|
    config.name = "Default Name"

    config.theme = [
        color_primary: "#193d8d",
        color_sidebar: "#ffffff",
        color_header: "transparent",
        color_footer: "transparent",
        color_background: "#eef2f6",
        color_sidebar_hover: "#dee7ec"
    ]

    config.locales = {
        en: "English",          # English
        # :de => "Deutsch",     # Deutsch/German
        # :pl => "Polski",      # Polski/Polish/Poland
        # :nl => "Dutch",       # Dutch/Nederlands/Netherlands
        :es => "Español",       # Español/Spanish
        # :uk => "украї́нська",  # украї́нська/Ukrainian
        # :sr => "Српски",      # Српски/Srpski/Serbian
        # :it => "Italiano",    # Italiano/Italian
        # :hr => "Hrvatski",    # Hrvatski/Croatian
        # :fr => "Français",    # French
        # :pt => "Português",   # Portuguese
        # :tr => "Türkçe",      # Turkish
        # :ro => "Română",      # Romanian
        # :bg => "български"    # Bulgarian
    }
end
