class CreateUserWebpushes < ActiveRecord::Migration[6.1]
    def change
        create_table :user_webpushes do |t|
            t.string    :user_agent
            t.string    :endpoint
            t.string    :auth_key
            t.string    :p256dh_key

            t.datetime :deleted_at, index: true
            t.timestamps
        end
        add_reference :user_webpushes, :users, foreign_key: true
    end
end
