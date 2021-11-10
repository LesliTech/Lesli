# Test generator
Creates standard test scaffold for lesli application CRUDs

__Example:__

```text
rails generate test cloud_focus/tasks
```

This will create:

```text
    /engines/cloud_focus/spec/requests/tasks/create_spec.rb
    /engines/cloud_focus/spec/requests/tasks/destroy_spec.rb
    /engines/cloud_focus/spec/requests/tasks/index_spec.rb
    /engines/cloud_focus/spec/requests/tasks/show_spec.rb
    /engines/cloud_focus/spec/requests/tasks/update_spec.rb
    /engines/cloud_focus/spec/lib/version_spec.rb (if does not exist)
```


__Example:__

```text
rails generate test cloud_development/abouts
```

This will create:

```text
    /engines/cloud_development/spec/requests/abouts/create_spec.rb
    /engines/cloud_development/spec/requests/abouts/destroy_spec.rb
    /engines/cloud_development/spec/requests/abouts/index_spec.rb
    /engines/cloud_development/spec/requests/abouts/show_spec.rb
    /engines/cloud_development/spec/requests/abouts/update_spec.rb
    /engines/cloud_development/spec/lib/version_spec.rb (if does not exist)
```


__Example:__

```text
rails generate test core/settings
```

This will create:

```text
    /spec/requests/settings/create_spec.rb
    /spec/requests/settings/destroy_spec.rb
    /spec/requests/settings/index_spec.rb
    /spec/requests/settings/show_spec.rb
    /spec/requests/settings/update_spec.rb
```
