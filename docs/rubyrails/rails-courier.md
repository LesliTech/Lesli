# Lesli Courier

Every communication between engines must be by the Lesli Courier. This is a group of class methods ordered by modules, each of this methods represents one the repective module.

The main functionality of the Courir provides is the validation of the existence of the module before using it and this avoids errors of existence.

As an example, let's say we are working on CloudDriver and we what to show all the tasks (of CloudFocus) in the calendar view. So there is the CloudFocus::Task model that looks like this:

```ruby
module CloudFocus
    class Task < CloudObject::Base
        def self.index(current_user, query)
            []
        end

        def show(current_user, query)
            self
        end
    end
end
```
The location where the methods of an engine for Courrier are declared is: 
/lib/[Engine Name]

Example:

>  /lib/focus/task.rb

If we want to access these methods from another engine like CloudDriver, there must be on Courier the following:

```ruby
module Courier
    module Focus
        class Task
            def self.index(current_user, query)
                return [] unless defined? CloudFocus
                CloudFocus::Task.index(current_user, query)
            end

            def self.show(current_user, query, tasks_id)
                return nil unless defined? CloudFocus
                task = CloudFocus::Task.find(tasks_id)
                task.show
            end

            def self.create(current_user, task_params)
                return unless defined? CloudFocus
                task = CloudFocus::Task.new(task_params)
                task.account = current_user.account.focus
                task.set_workflow
                task.save!
            end
        end
    end
end
```
