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

            def self.stats_pretty location, unit='MB'
                stats = stats(location, unit)
                {
                    :used_space => stats[:used_space].to_s << '%',
                    :total_space => stats[:total_space].to_s << stats[:unit],
                    :free_space => stats[:free_space].to_s << stats[:unit]
                }
            end

        end

    end

end
