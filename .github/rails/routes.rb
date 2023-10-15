
Rails.application.routes.draw do
    mount Lesli::Engine => "/lesli"
    mount LesliDriver::Engine => "/driver" if defined?(LesliDriver)
    mount LesliAdmin::Engine => "/admin" if defined?(LesliAdmin)
    mount LesliAudit::Engine => "/audit" if defined?(LesliAudit)
    mount LesliVault::Engine => "/vault" if defined?(LesliVault)
    mount LesliBabel::Engine => "/babel" if defined?(LesliBabel)
    mount LesliBell::Engine => "/bell" if defined?(LesliBell)
end
