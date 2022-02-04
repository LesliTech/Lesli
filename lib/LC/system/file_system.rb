=begin

Copyright (c) 2020, all rights reserved.

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

require 'sys/filesystem'
include Sys

module LC

    module System
        
        class FileSystem
            KB = 1024
            MB = 1048576
            GB = 1073741824
            TB = 1099511627776

            def self.stats location, unit='MB'

                stats = ::Filesystem.stat(location)

                total_space = stats.blocks * stats.block_size
                free_space = stats.blocks_available * stats.block_size

                used_space_percentage = 100 - ((free_space * 100) / total_space)
    
                if unit == 'KB'
                    total_space = total_space / KB
                    free_space = free_space / KB 
                end

                if unit == 'MB'
                    total_space = total_space / MB
                    free_space = free_space / MB 
                end

                if unit == 'GB'
                    total_space = total_space / GB
                    free_space = free_space / GB 
                end

                if unit == 'TB'
                    total_space = total_space / TB
                    free_space = free_space / TB 
                end

                {
                    :used_space => used_space_percentage,
                    :total_space => total_space,
                    :free_space => free_space, 
                    :unit => unit 
                }
                
            end

        end

    end

end
