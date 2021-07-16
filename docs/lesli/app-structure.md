# App structure

## Rails structure

```plaintext

lesli.cloud/
    app/
        assets/
        controllers/
        interfaces
        helpers/
        jobs/
        mailers/
        models/
        services/
        views
        vue/

```

## Vue structure

```plaintext

lesli.cloud/
    lib/
        vue/
            cloud_objects/
            components/
                charts/
                tables/
                cards/
            functions/
            layout/
            panels/
            plugins/
            app.js
            app2.js
            public.js

```

## Vue dashboard structure

LesliDashboardComponent

```plaintext

lesli.cloud/
    lib/
        vue/
            widgets
                list-sessions-active.vue
                list-activities-last.vue

                core/
                cloud_focus/
                
    engines    
        cloud_focus/
            lib/
                vue/
                    list-tasks.vue
                    list-tasks-next.vue
                    list-tasks-pending.vue
                    show-tasks.vue
                    show-tasks-due.vue
        cloud_driver/
            lib/
                vue/
                    list-events.vue
                    list-events-overdue.vue
                    show-events.vue
                    show-events-past.vue
                    show-calendar.vue
```
