# Lesli Testing

## Rspec
```
lesli/
    app/
        assets/
        controllers/
        helpers/
        models/
        services/
    config/
        database.yml
    lib/
        LC/
        vue/
    lesli.rb
    lesli.yml

    spec/
        assets/
        config/
            database.yml
            lesli.rb
            lesli.yml
        controllers/
        helpers/
        lib/
            courier/
            LC/
        models/
        requests/
        services/
        cloud_objects/  <--- (Evaluating) How to test abstract classes on core??
        mailers/        <--- (Evaluating) It's worth it??
        views/          <--- (Evaluating) It's worth it??
        features/       <--- (Evaluating) It's worth it??
        routing/        <--- (Evaluating) It's worth it??
        jobs/           <--- (Evaluating) It's worth it??
        systems/        <--- (Evaluating) It's worth it??
```

## LesliShield
```
LesliShield/
    gui/
        administration/
        core/
```

## LesliBullet
```
LesliBullet/
```

## Tasks Planning

- Requirements:
    - Minimum 2 tests for each method (one successful and another unsuccessful)
    - Remove all actions controllers that are not in use

- 25/10/2021 y 01/11/2021
    - (Rspec) Learn about Ruby
    - (Rspec) Learn about Ruby on Rails
    - (Rspec) Intro Lesli Core
    - (Rspec) Learn about Rspec
    - (Rspec) Read about Model tests - https://relishapp.com/rspec/rspec-rails/v/5-0/docs/model-specs
    - (Rspec) Read about Request tests - https://relishapp.com/rspec/rspec-rails/v/5-0/docs/request-specs/request-spec
    - (Rspec) Test Config files (database.yml, lesli.yml, lesli.rb)
    - (Rspec) Request Test controllers/accounts_controller
        - show, create, update, destroy, options
    - (Rspec) Request Test controllers/account/files_controller
        - index, show, create, update, destroy

- 08/11/2021
    - (Rspec) Request Test controllers/account/settings_controller
        - index, create, destroy, options
    - (Rspec) Request Test controllers/account/integrations_controller
        - index, show, create, update, destroy
    - (Rspec) Request Test controllers/abouts_controller
        - version
    - (Rspec) Request Test controllers/account/locations_controller
        - index, show, create

- 15/11/2021
    - (Rspec) Request Test controllers/account/activities_controller
        - index, create, update, destroy
    - (Rspec) Request Test controllers/account/currencies_controller
        - index, show, create, update, destroy, list
    - (Rspec) Request Test controllers/account/currency/exchange_rates_controller
        - index, show, create, update, destroy
    - (Rspec) Request Test controllers/account/cronos_controller
        - index, show, create, update, destroy

- 22/11/2021
    - (Rspec) Request Test controllers/errors_controller
        - unauthorized, not_found, internal_server_error
    - (Rspec) Request Test controllers/invites_controller
        - show, create
    - (Rspec) Request Test controllers/onboardings_controller
        - show, create, invite
    - (Rspec) Request Test controllers/otps_controller
        - show, create
    - (Rspec) Request Test controllers/passes_controller
        - show, create

- 29/11/2021
    - (Rspec) Request Test controllers/profiles_controller
        - show
    - (Rspec) Request Test controllers/profile/notifications_controller
        - index, update
    - (Rspec) Request Test controllers/profile/subscriptions_controller
        - index, options
    - (Rspec) Request Test controllers/profile/webpushes_controller
        - index, create
    - (Rspec) Request Test controllers/role_descriptors_controller
        - list, index, show, create, update, destroy

- 06/12/2021
    - (Rspec) Request Test controllers/role_descriptor/activities_controller
        - index, show, create, update, destroy
    - (Rspec) Request Test controllers/role_descriptor/provilege_actions_controller
        - index, create, update, options
    - (Rspec) Request Test controllers/roles_controller
        - list, index, show, create, update, destroy, options, roles_old_2, roles_old
    - (Rspec) Request Test controllers/role/activities_controller
        - index, options

- 13/12/2021
    - (Rspec) Request Test controllers/role/descriptor_assignments_controller
        - index, create, destroy, options
    - (Rspec) Request Test controllers/role/overrides_controller
    - (Rspec) Request Test controllers/system_activities_controller
    - (Rspec) Request Test controllers/system_controllers_controller
        - index, show, create, update, destroy
    - (Rspec) Request Test controllers/system_controllers/actions_controller
        - index, show, create, update, destroy

- 20/12/2021
    - (Rspec) Request Test controllers/users_controller
        - list, index, show, create, update, destroy, options, become, logout, lock, password, email
    - (Rspec) Request Test controllers/users/confirmations_controller
        - show, create
    - (Rspec) Request Test controllers/users/passwords_controller
        - create, update
    - (Rspec) Request Test controllers/users/registrations_controller
        - create, update
    - (Rspec) Request Test controllers/users/sessions_controller
        - create, destroy

- 03/01/2022
    - (Rspec) Request Test controllers/user/access_codes_controller
        - index, show, create, update, destroy
    - (Rspec) Request Test controllers/user/activities_controller
    - (Rspec) Request Test controllers/user/details_controller
    - (Rspec) Request Test controllers/user/logs_controller
    - (Rspec) Request Test controllers/user/passwords_controller
        - update
    - (Rspec) Request Test controllers/user/privilege_actions_controller
        - index, show, create, update, destroy
    - (Rspec) Request Test controllers/user/requests_controller
    - (Rspec) Request Test controllers/user/roles_controller
        - create, destroy
    - (Rspec) Request Test controllers/user/sessions_controller
        - index, destroy
    - (Rspec) Request Test controllers/user/settings_controller
    - (Rspec) Request Test controllers/user/shortcuts_controller
        - index, create, update, destroy

    (PLANNING IN PROGRESS)
    - (Rspec) Request Test controllers/templates y template/
    - (Rspec) Request Test controllers/application_controller
    - (Rspec) Request Test controllers/application_lesli_controller
    - (Rspec) Model Test controllers/concerns/
    - (Rspec) Model Test controllers/shared/
    - (Rspec) Model Test controllers/interfaces/
    - (Rspec) Model Test models/account and account/
    - (Rspec) Model Test models/application_lesli_record
    - (Rspec) Model Test models/cloud_object and cloud_object/
    - (Rspec) Model Test models/role_descriptor and role_descriptor/
    - (Rspec) Model Test models/role and role/
    - (Rspec) Model Test models/system_activity
    - (Rspec) Model Test models/user and user/
    - (Rspec) Model Test models/profile/
    - (Rspec) Model Test models/shared/
    - (Rspec) Model Test services/user_registrarion_service
    - (Rspec) Model Test services/user_validation_service
    - (Rspec) Model Test services/cloud_object/
    - (Rspec) Model Test services/role_descriptor
    - (Rspec) Helper tests - https://relishapp.com/rspec/rspec-rails/v/5-0/docs/helper-specs/helper-spec
    - (Rspec) Controller tests - https://relishapp.com/rspec/rspec-rails/v/5-0/docs/controller-specs
    - (Rspec) Assets tests - Rails.application.assets.find_asset “my_image.png”
    - (Rspec) Model tests lib/

- Week #
    - (LesliShield) Learn about Playwright
    - (LesliShield) Login
    - (LesliShield) Logout
    - (LesliShield) Change Language
    - (LesliShield) Create announcement
    - (LesliShield) See notifications
    - (LesliShield) Open engines navigations
    - (LesliShield) Go to profile
    - (LesliShield) Go to dashboard
    - (LesliShield) Navigate to all engines
    - (LesliShield) Navigate to administration and navigate on sidebar options
- Week #
    - (LesliShield) Reset Password
    - (LesliShield) Request a Pass
    - (LesliShield) Create account
    - (LesliShield) Onboarding
    - (LesliShield) Reload users, search user, filter by role/active and change pagination
    - (LesliShield) Create user
    - (LesliShield) Show and edit user, navigate on tabs, change status, and email
    - (LesliShield) Assing role and remove role from user
    - (LesliShield) delete sesssion
    - (LesliShield) Request password change, force logout, revoke acess, delete user
- Week #
    - (LesliShield) Add new integration
    - (LesliShield) Search role descriptor, reload, change pagination, create role descriptor
    - (LesliShield) Show and edit role descriptor
    - (LesliShield) Add/Remove permissions to role descriptor
    - (LesliShield) Delete role descriptor
    - (LesliShield) Search role, reload, change pagination, create role
    - (LesliShield) Create role, assign role descriptors
    - (LesliShield) Show and edit role, show role logs (search, filter and change pagination)
    - (LesliShield) Show users on role
- Week #
    - (LesliShield) Search, reload and create exchange currency
    - (LesliShield) Add/Remove exchange rates
    - (LesliShield) Delete currency
    - (LesliShield) Change password settings
    - (LesliShield) Change datetime settings
    - (LesliShield) Change branding settings
    - (LesliShield) Change theme settings
