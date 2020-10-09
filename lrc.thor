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

module LesliRubyConsole
    def self.load_thorfiles(dir)
        Dir.chdir(dir) do
            thor_files = Dir.glob('**/*.thor').delete_if { |x| not File.file?(x) }
            thor_files.each do |f|
                Thor::Util.load_thorfile(f)
            end
        end
    end
end

Foo.load_thorfiles('./lib/thor/git')
