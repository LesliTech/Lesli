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
                core/
                    list-sessions-active.vue
                    list-activities.vue
                    list-shortcuts.vue
                    list-actions.vue
                    settings-list.vue
                    settings-table.vue
                    settings-chart.vue
                cloud_focus/
                    list-tasks.vue
                        next
                        pending
                        overdue
                    show-task-next.vue
                cloud_driver/
                    list-events.vue
                        overdue
                        past
                    show-calendar.vue
                    show-event.vue

```
