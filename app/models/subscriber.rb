class Subscriber < ApplicationRecord
    self.abstract_class = true

    belongs_to :user, class_name: "User", foreign_key: "users_id"

    enum event: [
        :comment_created,
        :action_created,
        :file_created,
        :activity_created,
        :workflow_updated,
        :priority_updated,
        :http_get,
        :http_post,
        :http_put,
        :http_patch,
        :http_update
    ]
    validates :event, presence: true, inclusion: { in: :event }

    enum notification_type: [
        :web,
        :email
    ]
    validates :notification_type, presence: true, inclusion: { in: :notification_type }
end
