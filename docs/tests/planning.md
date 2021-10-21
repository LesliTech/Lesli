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

- Week 1
    - (Rspec) Learn about Ruby
    - (Rspec) Learn about Ruby on Rails
    - (Rspec) Intro Lesli Core
    - (Rspec) Learn about Rspec
    - (Rspec) Read about Model tests - https://relishapp.com/rspec/rspec-rails/v/5-0/docs/model-specs
    - (Rspec) Read about Request tests - https://relishapp.com/rspec/rspec-rails/v/5-0/docs/request-specs/request-spec
    - (Rspec) Test Config files (database.yml, lesli.yml, lesli.rb)
    - (Rspec) Request Test controllers/application_controller
    - (Rspec) Request Test controllers/application_lesli_controller
    - (Rspec) Request Test controllers/abouts_controller
    - (Rspec) Request Test controllers/accounts_controller and account/
- Week 2
    - (Rspec) Request Test controllers/users/
    - (Rspec) Request Test controllers/errors_controller
    - (Rspec) Request Test controllers/invites_controller
    - (Rspec) Request Test controllers/onboardings_controller
    - (Rspec) Request Test controllers/otps_controller
- Week 3
    - (Rspec) Request Test controllers/passes_controller
    - (Rspec) Request Test controllers/profiles_controller and profile/
    - (Rspec) Request Test controllers/role_descriptors_controller and role_descriptor/
    - (Rspec) Request Test controllers/roles_controller and role/
    - (Rspec) Request Test controllers/users_controller and user/
    - (Rspec) Model Test controllers/concerns/
- Week 4
    - (Rspec) Model Test models/account and account/
    - (Rspec) Model Test models/application_lesli_record
    - (Rspec) Model Test models/cloud_object and cloud_object/
    - (Rspec) Model Test models/role_descriptor and role_descriptor/
    - (Rspec) Model Test models/role and role/
    - (Rspec) Model Test models/system_activity
- Week 5
    - (Rspec) Model Test models/user and user/
    - (Rspec) Model Test models/profile/
    - (Rspec) Model Test models/shared/
    - (Rspec) Model Test services/user_registrarion_service
    - (Rspec) Model Test services/user_validation_service
    - (Rspec) Model Test services/cloud_object/
    - (Rspec) Model Test services/role_descriptor
- Week 6
    (PLANNING IN PROGRESS)
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
