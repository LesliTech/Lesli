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
                class Ec2
                    def initialize(credentials = nil)

                        if (!credentials) && Rails.application.credentials.providers[:aws][:ec2]
                            credentials = {
                                region: Rails.application.credentials.providers[:aws][:ec2][:region],
                                access_key_id: Rails.application.credentials.providers[:aws][:ec2][:access_key_id],
                                secret_access_key: Rails.application.credentials.providers[:aws][:ec2][:secret_access_key]
                            }
                        end
                        
                        credentials = {} unless credentials

                        @client = ::Aws::EC2::Client.new(credentials)
                        @resource = ::Aws::EC2::Resource.new(client: @client)
                    end

                    def get_instance(instance_id)
                        begin
                            instance = @resource.instance(instance_id)

                            parse_instance(instance)
                        rescue StandardError => e
                            puts "There was an error while retrieving the  instance's information #{instance_id}: #{e.message}"
                            return false
                        end
                    end

                    def reboot_instance(instance_id)
                        begin
                            aws_response = @client.describe_instance_status(instance_ids: [instance_id])

                            if aws_response.instance_statuses.count.positive?
                                intance_status = aws_response.instance_statuses[0].instance_state.name

                                case intance_status
                                when "running"
                                    @client.reboot_instances(instance_ids: [instance_id])
                                    return true
                                    
                                when "stopping"
                                    @client.wait_until(:instance_stopped, instance_ids: [instance_id])
                                    self.start_instance(instance_id)
                                    return true

                                when "stopped"
                                    self.start_instance(instance_id)
                                    return true

                                when "pending"
                                    @client.wait_until(:instance_running, instance_ids: [instance_id])
                                    return true

                                when "terminated"
                                    puts "The instance #{instance_id} has been terminated and cannot be rebooted"
                                    return false
                                end

                            else
                                puts "The instance #{instance_id} was not found or is not accessible"
                                return false
                            end
                        rescue StandardError => e
                            puts "There was an error while rebooting  instance #{instance_id}: #{e.message}"
                            return false
                        end
                    end

                    def stop_instance(instance_id)
                        @client.stop_instances(instance_ids: [instance_id])
                    end

                    def start_instance(instance_id)
                        @client.start_instances(instance_ids: [instance_id])
                    end

                    def list_instances
                        instances = []

                        begin
                            response = @resource.instances
                            response.each do |instance|
                                instances.push(parse_instance(instance))
                            end

                            instances
                        rescue StandardError => e
                            puts "There was an error while listing instances: #{e.message}"
                            return []
                        end
                    end

                    protected

                    def parse_instance(instance)
                        {
                            id: instance.id,
                            type: instance.instance_type,
                            tags: instance.tags,
                            status: instance.state.name,
                            service: "EC2",
                            availability_zone: instance.placement.availability_zone,
                            public_ip: instance.public_ip_address
                        }
                    end

                end
            end
        end
    end
end
