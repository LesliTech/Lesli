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
