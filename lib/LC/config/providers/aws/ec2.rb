module LC
    module Config
        module Providers
            module Aws
                class Ec2
                    def initialize
                        @client = ::Aws::EC2::Client.new()
                        @resource = ::Aws::EC2::Resource.new()

                        if Rails.application.credentials.providers[:aws][:ec2]
                            ec2_credentials = {
                                region: Rails.application.credentials.providers[:aws][:ec2][:region],
                                access_key_id: Rails.application.credentials.providers[:aws][:ec2][:access_key_id],
                                secret_access_key: Rails.application.credentials.providers[:aws][:ec2][:secret_access_key]
                            }

                            @client = ::Aws::EC2::Client.new(ec2_credentials)
                            @resource = ::Aws::EC2::Resource.new(client: @client)
                        end
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
                        response = @resource.instances

                        response.each do |instance|
                            instances.push(parse_instance(instance))
                        end

                        instances
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
