module LC
    module Config
        module Providers
            module Aws
                class Sns
                    def initialize
                        @client = ::Aws::SNS::Client.new()

                        if Rails.application.credentials.providers[:aws][:sns]
                            sns_credentials = {
                                region: Rails.application.credentials.providers[:aws][:sns][:region],
                                access_key_id: Rails.application.credentials.providers[:aws][:sns][:access_key_id],
                                secret_access_key: Rails.application.credentials.providers[:aws][:sns][:secret_access_key]
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
