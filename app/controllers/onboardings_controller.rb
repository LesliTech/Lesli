=begin
Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class OnboardingsController < ApplicationLesliController

    # GET /onboarding
    def show
        respond_to do |format|
            format.html {}
            format.json do
                account = Account.find_by_id(@current_user.account.id)
                return respond_with_not_found unless account
                return respond_with_successful({
                    account: account,
                    account_settings: account.settings
                })
            end
        end
    end


    # POST /onboarding
    def create

        account = Account.find_by_id(@current_user.account.id)

        if account.update(onboarding_params[:account]) && account.settings.update(@current_user, onboarding_params[:account_settings])
            respond_with_successful(account)
        else
            respond_with_error(account.errors.full_messages.to_sentence)
        end

    end

    def onboarding_params
        params.require(:onboarding).permit(
            account: {},
            account_settings: [
                :password_enforce_complexity,
                :password_minimum_length,
                :password_expiration_time_days,
                :password_special_char_count,
                :password_uppercase_count,
                :password_lowercase_count,
                :password_digit_count,
                :datetime_time_zone,
                :datetime_start_week_on,
                :datetime_format_date,
                :datetime_format_time,
                :datetime_format_date_time,
                :datetime_format_date_words,
                :datetime_format_date_time_words,
            ]
        )
    end

end
