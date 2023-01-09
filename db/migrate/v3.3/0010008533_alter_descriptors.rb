# Copyright (c) 2023, all rights reserved.

# All the information provided by this platform is protected by international laws related  to 
# industrial property, intellectual property, copyright and relative international laws. 
# All intellectual or industrial property rights of the code, texts, trade mark, design, 
# pictures and any other information belongs to the owner of this platform.

# Without the written permission of the owner, any replication, modification,
# transmission, publication is strictly forbidden.

# For more information read the license file including with this software.

# // · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
# // · 


class AlterDescriptors < ActiveRecord::Migration[7.0]
    def change
        add_column  :descriptors,   :description,       :text
        add_column  :descriptors,   :descriptors_id,    :bigint
        add_index   :descriptors,   :descriptors_id
    end
end
