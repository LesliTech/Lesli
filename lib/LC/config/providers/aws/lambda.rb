module LC
    module Config
        module Providers
            module Aws
                class Lambda
                    require "aws-sdk-lambda"

                    def initialize
                        
                        @client = ::Aws::Lambda::Client.new()
                        if Rails.application.credentials.providers[:aws][:lambda]
                            lambda_credentials = {
                                region: self.class.region,
                                access_key_id: Rails.application.credentials.providers[:aws][:lambda][:access_key_id],
                                secret_access_key: Rails.application.credentials.providers[:aws][:lambda][:secret_access_key]
                            }

                            @client = ::Aws::Lambda::Client.new(lambda_credentials)
                        end

                        self
                    end

                    def invoke(function_name, params)
                        params = JSON.generate(params)

                        @client.invoke({
                            function_name: function_name,
                            invocation_type: "Event",
                            log_type: "None",
                            payload: params
                        })
                    end

                    private

                    def self.region
                        region = Rails.application.credentials.providers[:aws][:region]
                        region = Rails.application.credentials.providers[:aws][:lambda][:region] if Rails.application.credentials.providers[:aws][:lambda][:region]
                        region
                    end
                end
            end
        end
    end
end
