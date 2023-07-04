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
                class Lightsail
                    def initialize(credentials = nil)

                        if (!credentials) && Rails.application.credentials.providers[:aws][:ec2]
                            credentials = {
                                region: Rails.application.credentials.providers[:aws][:ec2][:region],
                                access_key_id: Rails.application.credentials.providers[:aws][:ec2][:access_key_id],
                                secret_access_key: Rails.application.credentials.providers[:aws][:ec2][:secret_access_key]
                            }
                        end
                        
                        credentials = {} unless credentials

                        @client = ::Aws::Lightsail::Client.new(credentials)
                    end

                    def reboot_instance(instance_id)
                        begin
                            aws_response = @client.reboot_instance(instance_name: instance_id)

                            if aws_response.operations[0]["status"] == "Succeeded"
                                return true
                            else
                                error = aws_response.operations[0]["error_details"]
                                puts "There was an error while rebooting  instance #{instance_id}: #{error}"
                                return false
                            end
                        rescue StandardError => e
                            puts "There was an error while rebooting  instance #{instance_id}: #{e.message}"
                            return false
                        end
                    end

                    def stop_instance(instance_id)
                        begin
                            aws_response = @client.stop_instance(instance_name: instance_id)

                            puts aws_response.operations.to_json

                            if (aws_response.operations[0]["status"] == "Succeeded") || (aws_response.operations[0]["status"] == "Started")
                                return true
                            else
                                error = aws_response.operations[0]["error_details"]
                                puts "There was an error while rebooting  instance #{instance_id}: #{error}"
                                return false
                            end
                        rescue StandardError => e
                            puts "There was an error while rebooting  instance #{instance_id}: #{e.message}"
                            return false
                        end
                    end

                    def start_instance(instance_id)
                        begin
                            aws_response = @client.start_instance(instance_name: instance_id)

                            if (aws_response.operations[0]["status"] == "Succeeded") || (aws_response.operations[0]["status"] == "Started")
                                return true
                            else
                                error = aws_response.operations[0]["error_details"]
                                puts "There was an error while rebooting  instance #{instance_id}: #{error}"
                                return false
                            end
                        rescue StandardError => e
                            puts "There was an error while rebooting  instance #{instance_id}: #{e.message}"
                            return false
                        end
                    end

                    def list_instances
                        instances = []
                        response = @client.get_instances

                        response.instances.each do |instance|
                            instances.push(parse_instance(instance))
                        end

                        instances
                    end

                    def get_instance(instance_id)
                        begin
                            instance = @client.get_instance(instance_name: instance_id).instance

                            parse_instance(instance)
                        rescue StandardError => e
                            puts "There was an error while retrieving the  instance's information #{instance_id}: #{e.message}"
                            return false
                        end
                    end

                    protected

                    def parse_instance(instance)
                        {
                            id: instance.name,
                            type: "#{instance.blueprint_name} #{instance.bundle_id}",
                            tags: instance.tags,
                            service: "Lightsail",
                            status: instance.state.name,
                            availability_zone: instance.location.availability_zone,
                            public_ip: instance.public_ip_address
                        }
                    end

                end
            end
        end
    end
end
