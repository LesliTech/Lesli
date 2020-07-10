=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@author   Carlos Hermosilla
@license  Propietary - all rights reserved.
@version  0.1.0-alpha
@description Base abstract model for *file* core entity

=end

module CloudObject

    class CustomField < ApplicationLesliRecord
        self.abstract_class = true
        belongs_to :user_creator, class_name: "::User", foreign_key: "users_id"

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
end
