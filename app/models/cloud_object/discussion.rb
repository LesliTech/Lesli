module CloudObject
    class Discussion < ApplicationRecord
        self.abstract_class = true

        def self.detailed_info(account, cloud_id)

            module_info = self.name.split("::")
            module_name = module_info[0].sub("Cloud","").downcase
            object_name = module_info[1].downcase
            
            discussions = self.joins(
                "inner join cloud_#{module_name}_#{object_name}s CO on cloud_#{module_name}_#{object_name}_discussions.cloud_#{module_name}_#{object_name}s_id = CO.id"
            ).joins(
                "inner join users U on cloud_#{module_name}_#{object_name}_discussions.users_id = U.id"
            ).select(
                "cloud_#{module_name}_#{object_name}_discussions.id",
                "cloud_#{module_name}_#{object_name}_discussions.content",
                "cloud_#{module_name}_#{object_name}_discussions.created_at",
                "cloud_#{module_name}_#{object_name}_discussions.cloud_#{module_name}_#{object_name}_discussions_id",
                "U.email"
            )
            .where("CO.id = #{cloud_id}")
            .where("CO.cloud_#{module_name}_accounts_id = #{account.id}")
            .order(id: :asc)
            .map { |discussion| discussion.attributes }

            data = {}
            root_discussions = []

            discussions.each do |discussion|
                discussion_data = {
                    data: discussion,
                    responses: []
                }
                data[discussion["id"]] = discussion_data

                if discussion["cloud_#{module_name}_#{object_name}_discussions_id"].present?
                    parent_discussion = data[discussion["cloud_#{module_name}_#{object_name}_discussions_id"]]
                    if parent_discussion[:data]["cloud_#{module_name}_#{object_name}_discussions_id"].present?
                        discussion["response_to"] = parent_discussion[:data]["email"]
                    end
                    parent_discussion[:responses].push(discussion["id"])
                else
                    root_discussions.push(discussion_data)
                end
            end

            root_discussions.each do |discussion|
                responses = []
                self.nest_responses(data, discussion, responses)
                discussion[:responses] = responses
            end

            # revert the discussions so the most recent comments appear in front
            root_discussions.reverse

        end

        
        def self.nest_responses(data, discussion,  responses)
            discussion[:responses].each do |response_id|
                response = data[response_id]
                responses.push(response[:data])
                self.nest_responses(data, response, responses)
            end
        end
    end
end
