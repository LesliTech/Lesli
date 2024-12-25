module Lesli
    module CustomizationInterface

        # set customization only for lesli_cloud instance
        def set_customizer
=begin
            # @account is only for html and pdf requests
            return unless request.format.html? || request.format.pdf?

            # return unless Lesli.instance[:code] == "lesli_cloud"

            @lesli[:customization] = {}

            logos = {}
            # logo_identifiers = Account::File.file_types.keys
            # custom_logos = current_user.account.files.where("file_type in (?)", logo_identifiers).order(id: :desc).all
            # logo_identifiers.each do |logo_identifier|
            #     custom_logo = custom_logos.find { |logo| logo.file_type == logo_identifier}
            #     next unless custom_logo

            #     custom_logo_url = "/administration/account/files/#{custom_logo.id}"
            #     custo_logo_url = custom_logo.attachment_url if custom_logo.attachment_identifier
            #     custom_logo_url = custom_logo.attachment_public_url if custom_logo.attachment_public_identifier

            #     logos[logo_identifier.to_sym] = custom_logo_url
            # end
            @lesli[:customization][:logos] = logos

            colors = {}
            # color_identifiers = ::Account::Setting.theme_settings_keys
            # custom_colors = current_user.account.settings.where("name in (?)", color_identifiers).all
            # color_identifiers.each do |color_identifier|
            #     custom_color = custom_colors.find { |color| color.name == color_identifier}
            #     next unless custom_color

            #     colors[color_identifier.to_sym] = custom_color.value
            # end
            @lesli[:customization][:colors] = colors
=end
        end
    end
end
