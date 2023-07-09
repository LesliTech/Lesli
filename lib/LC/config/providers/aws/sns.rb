=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

module LC
    module Config
        module Providers
            module Aws
                class Sns
                    def initialize
                        
                        @client = nil

                        if Rails.application.credentials.dig(:providers, :aws, :sns).present?

                            sns_credentials = {
                                region: Rails.application.credentials.dig(:providers, :aws, :sns, :region),
                                access_key_id: Rails.application.credentials.dig(:providers, :aws, :sns, :access_key_id),
                                secret_access_key: Rails.application.credentials.dig(:providers, :aws, :sns, :secret_access_key)
                            }

                            @client = ::Aws::SNS::Client.new(sns_credentials)

                            self
                        end
                    end

                    def publish(data_hash)
                        @client.publish(data_hash)
                    end
                end
            end
        end
    end
end
