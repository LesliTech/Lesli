module LC
    module Config
        module Providers
            module Aws
                class Ec2
                    def initialize
                        @client = ::Aws::EC2::Client.new()

                        if Rails.application.credentials.providers[:aws][:ec2]
                            ec2_credentials = {
                                region: Rails.application.credentials.providers[:aws][:ec2][:region],
                                access_key_id: Rails.application.credentials.providers[:aws][:ec2][:access_key_id],
                                secret_access_key: Rails.application.credentials.providers[:aws][:ec2][:secret_access_key]
                            }

                            @client = ::Aws::EC2::Client.new(ec2_credentials)
                        end
                    end

                    def reboot_instance(instance_id)
                        begin
                            aws_response = @client.describe_instance_status(instance_ids: [instance_id])

                            if aws_response.instance_statuses.count.positive?
                                intance_status = aws_response.instance_statuses[0].instance_state.name

                                case intance_status
                                when "running"
                                    self.stop_instance(instance_id)
                                    self.start_instance(instance_id)
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
                        @client.wait_until(:instance_stopped, instance_ids: [instance_id])
                    end

                    def start_instance(instance_id)
                        @client.start_instances(instance_ids: [instance_id])
                        @client.wait_until(:instance_running, instance_ids: [instance_id])
                    end
                end
            end
        end
    end
end
