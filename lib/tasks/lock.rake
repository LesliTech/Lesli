namespace :lock do

    desc "Create standard structure for privileges according to the objects in the app"
    task scan: [:environment] do
        scan_roles()
    end

    def scan_roles()
        role_list = []

        role_list = get_controllers_from_routes(role_list, Rails.application.routes.routes, "")
        role_list = get_controllers_from_routes(role_list, CloudTeam::Engine.routes.routes, CloudTeam) if defined?(CloudTeam)
        role_list = get_controllers_from_routes(role_list, CloudDriver::Engine.routes.routes, CloudDriver) if defined?(CloudDriver)
        role_list = get_controllers_from_routes(role_list, CloudLesli::Engine.routes.routes, CloudLesli) if defined?(CloudLesli)
        role_list = get_controllers_from_routes(role_list, CloudBell::Engine.routes.routes, CloudBell) if defined?(CloudBell)
        role_list = get_controllers_from_routes(role_list, CloudHelp::Engine.routes.routes, CloudHelp) if defined?(CloudHelp)
        role_list = get_controllers_from_routes(role_list, CloudPanel::Engine.routes.routes, CloudPanel) if defined?(CloudPanel)
        role_list = get_controllers_from_routes(role_list, CloudBabel::Engine.routes.routes, CloudBabel) if defined?(CloudBabel)
        role_list = get_controllers_from_routes(role_list, DeutscheLeibrenten::Engine.routes.routes, DeutscheLeibrenten) if defined?(DeutscheLeibrenten)
        role_list = get_controllers_from_routes(role_list, CloudHouse::Engine.routes.routes, CloudHouse) if defined?(CloudHouse)
        role_list = get_controllers_from_routes(role_list, CloudFocus::Engine.routes.routes, CloudFocus) if defined?(CloudFocus)

        role_list.each do |t|
            role = Role.all
            role.each do |r|
                Role::Privilege.find_or_create_by!({ grant_object: t[:grant_name], roles_id: r.id})
            end
        end
    end

    def get_controllers_from_routes controller_list, routes, engine
        routes = routes.map{ |r| {controller: r.defaults[:controller] }}.uniq
        routes.each do |route|
            controller = route[:controller]
            next if !(controller.present?)
            next if controller.include? "rails"
            next if controller.include? "action_mailbox"
            next if controller.include? "active_storage"
            next if controller.include? "errors"

            controller_list.push({ grant_name: controller})
        end
        return controller_list
    end

end
