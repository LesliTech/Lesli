
class SystemDescriptor < ApplicationLesliRecord
    has_many :privileges
    has_many :role_descriptors, class_name: "Role::Descriptor"
    belongs_to :system_controller
    validates :name, presence: true

    #after_create :initialize_descriptor_privileges

    def initialize_descriptor_privileges

        # assign ["show", "update"] actions from profile descriptor to the role
        DescriptorService.add_profile_privileges(self) if self.name == "profile"

        DescriptorService.add_owner_privileges(self) if ["owner", "sysadmin"].include?(self.name)

    end


    def show(current_user, query)
        { 
            :id => self.id,
            :name => self.name,
            :description => self.description,
            :descriptors_id => self.descriptors_id,
            :privileges => self.privileges.joins(action: :system_controller).select(
                "descriptor_privileges.id",
                "system_controllers.name as controlle_name",
                "system_controller_actions.name as action_name",
                "descriptor_privileges.created_at"
            )
        }
    end

end
