=begin

Copyright (c) 2023, all rights reserved.

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

module Courier
    module Word
        class Post
            
            def self.index(current_user, query)
                return [] unless defined? CloudWord
                CloudWord::Post.index(current_user, query)
            end
            
            def self.show(current_user, query, post_id)
                return {} unless defined? CloudWord
                post = CloudWord::Post.find_by_id(post_id)
                post.show(current_user, query)
            end
            
            def self.create(current_user, params)
                return nil unless defined? CloudWord
                CloudWord::PostServices.create(current_user, params)
            end
            
            def self.update(current_user, params, post_id)
                return {} unless defined? CloudWord
                post = CloudWord::Post.find_by_id(post_id)
                post.update(params)
                return post
            end
            
            def self.destroy(current_user, post_id)
                return nil unless defined? CloudWord
                post = CloudWord::Post.find_by_id(post_id)
                CloudWord::PostServices.destroy(current_user, post)
            end
            
        end
    end
end