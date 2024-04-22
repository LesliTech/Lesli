=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class CloudObject::CustomField < ApplicationLesliRecord
    self.abstract_class = true
    belongs_to :user_creator, class_name: "::User", foreign_key: "users_id"

    # @return [User] This method will always return nil
    # @description At the current time, this is a dummy method that returns nil, so the function is_editable_by? in
    #   ApplicationLesliRecord will work without issues
    def user_main
        return nil
    end

=begin
    # @param cloud_object [ApplicationRecord] Cloud object to which an user can subscribe to
    # @param user [User] The user that is subscribing to the *cloud_ubject*
    # @param event [Symbol] A valid event from this class's *event* enum to wich the *user* will be subscribed
    # @param notification_type [Symbol] A valid notification_type from this class's *notification_type* enum
    # @return [void]
    # @description Subscribes a *user* to one or all *events* of the *cloud_object*. If no *event* is provided, the *user*
    #     is subscribed to all the *events*
    # @example
    #     first_ticket = CloudHelp::Ticket.find( 1 )
    #     second_ticket = CloudHelp::Ticket.find( 2 )
    #     user = current_user
    #     CloudHelp::Ticket::Subscriber.add_subscriber( first_ticket, current_user )
    #     CloudHelp::Ticket::Subscriber.add_subscriber( second_ticket, current_user, :http_post, :email )
    def self.add_subscriber(cloud_object, user, event=nil, notification_type= :web)
        model = dynamic_info[:model]

        if event
            return cloud_object.subscribers.create(
                user: user,
                event: event,
                notification_type: model.notification_types[notification_type]
            )
        end
        
        model.events.values.each do |event|
            cloud_object.subscribers.create(
                user: user,
                event: event,
                notification_type: model.notification_types[notification_type]
            )
        end
    end

    # @param cloud_object [ApplicationRecord] Cloud object to which an user can subscribe to
    # @param subject [String] The subject that will be shown in the notification
    # @param event [Symbol] A valid event from this class's *event* enum
    # @return [void]
    # @description Notifies all the users subscribed to the *cloud_object*'s *event* using the *Courier* engine
    # @example
    #     ticket = CloudHelp::Ticket.find( 1 )
    #     ClodHelp::Ticket::Subscriber.notify_subscribers(
    #         ticket,
    #         "A new comment has been added to ticket #{ticket.id}",
    #         :comment_created
    #     )
    def self.notify_subscribers(cloud_object, subject, event)
        module_name = dynamic_info[:module_name]
        object_name = dynamic_info[:object_name]

        cloud_object.subscribers.where(event: event).each do |subscriber|
            Courier::Bell::Notifications.send(
                user: subscriber.user,
                subject: subject,
                href: "#{module_name}/#{object_name}/#{cloud_object.id}",
                type: subscriber.notification_type,
                cloud_object_type: "#{module_name}/#{object_name}"
            )
        end
    end

    # @param cloud_object [ApplicationRecord] Cloud object to which an user can subscribe to
    # @param user [User] The user that is subscribing to the *cloud_object*
    # @return [Array] Array of subscriptions. There is one subscription per *event*.
    # @description Generates an array of subscription, Each element contains a subscription *event*, 
    #     information about wheter the *user* is subscribed or not and, if the user is subscribed, 
    #     the notification type of the subscription
    # @example
    #     ticket = CloudHelp::Ticket.find( 1 )
    #     subscription_events = CloudHelp::Ticket::Subscriber.subscription_events(
    #         ticket,
    #         current_user
    #     )
    def self.subscription_events(cloud_object, user)
        model = dynamic_info[:model]

        data = { }
        events = model.events.keys
        events.each do |event|
            data[event] = {
                event: event,
                subscribed: false,
                notification_type: :web
            }
        end
        cloud_object.subscribers.where(users_id: user.id).each do |subscriber|
            data[subscriber.event][:id] = subscriber.id
            data[subscriber.event][:subscribed] = true
            data[subscriber.event][:notification_type] = subscriber.notification_type
        end
        data.values
    end

    private

    # @return [Hash] Hash that contains information about the class
    # @description Returns dynamic information based on the current implementation of this abstract class
    # @example
    #     dynamic_info = CloudHelp::Ticket::Subscriber.dynamic_info
    #     puts dynamic_info[:module_name] # will print 'help'
    #     puts dynamic_info[:object_name] # will print 'ticket'
    #     dynamic_info.model.new # will return an instance of CloudHelp::Ticket::Subscriber
    def self.dynamic_info
        module_info = self.name.split("::")
        {
            module_name: module_info[0].sub("Cloud", "").downcase,
            object_name: module_info[1].downcase,
            model: "#{module_info[0]}::#{module_info[1]}::Subscriber".constantize
        }
    end
=end

end
