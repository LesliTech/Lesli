module CloudObject
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
    class Subscriber < ApplicationLesliRecord
        self.abstract_class = true
        belongs_to :user_creator, class_name: "::User", foreign_key: "users_id"

        # @return [User] This method will always return nil
        # @description At the current time, this is a dummy method that returns nil, so the function is_editable_by? in
        #   ApplicationLesliRecord will work without issues
        def user_main
            return nil
        end

=begin
@attribute [Enumerable<Symbol>] action
    @return [:discussion_created, :action_created, :file_created, :activity_created, :workflow_updated, :priority_updated, :http_get, :http_post, :http_put, :http_patch, :http_update]
=end
        enum action: {
            action_created: "action_created",
            action_updated: "action_updated",
            action_destroyed: "action_destroyed",

            discussion_created: "discussion_created",
            discussion_updated: "discussion_updated",
            discussion_destroyed: "discussion_destroyed",

            file_created: "file_created",
            file_updated: "file_updated",
            file_destroyed: "file_destroyed",

            activity_created: "activity_created",

            object_created: "object_created",
            object_updated: "object_updated",
            object_destroyed: "object_destroyed",
            object_status_updated: "object_status_updated"
        }
        validates :action, presence: true, inclusion: { in: :action }

=begin
@attribute [Enumerable<Symbol>] notification_type
    @return [:web, :email]
=end
        enum notification_type: {
            web: "web",
            email: "email"
        }
        validates :notification_type, presence: true, inclusion: { in: :notification_type }

=begin
@param cloud_object [ApplicationRecord] Cloud object to which an user can subscribe to
@param user [User] The user that is subscribing to the *cloud_ubject*
@param action [Symbol] A valid action from this class's *action* enum to wich the *user* will be subscribed
@param notification_type [Symbol] A valid notification_type from this class's *notification_type* enum
@return [void]
@description Subscribes a *user* to one or all *actions* of the *cloud_object*. If no *action* is provided, the *user*
    is subscribed to all the *actions*
@example
    first_ticket = CloudHelp::Ticket.find( 1 )
    second_ticket = CloudHelp::Ticket.find( 2 )
    user = current_user
    CloudHelp::Ticket::Subscriber.add_subscriber( first_ticket, current_user )
    CloudHelp::Ticket::Subscriber.add_subscriber( second_ticket, current_user, :http_post, :email )
=end
        def self.add_subscriber(cloud_object, user, action=nil, notification_type= :web)
            model = dynamic_info[:model]

            if action
                return cloud_object.subscribers.create(
                    user: user,
                    action: action,
                    notification_type: model.notification_types[notification_type]
                )
            end
            
            model.actions.values.each do |action|
                cloud_object.subscribers.create(
                    user: user,
                    action: action,
                    notification_type: model.notification_types[notification_type]
                )
            end
        end

        
=begin
@param cloud_object [ApplicationRecord] Cloud object to which an user can subscribe to
@param subject [String] The subject that will be shown in the notification
@param action [Symbol] A valid action from this class's *action* enum
@return [void]
@description Notifies all the users subscribed to the *cloud_object*'s *action* using the *Courier* engine
@example
    ticket = CloudHelp::Ticket.find( 1 )
    ClodHelp::Ticket::Subscriber.notify_subscribers(
        ticket,
        "A new comment has been added to ticket #{ticket.id}",
        :discussion_created
    )
=end
        def self.notify_subscribers(cloud_object, action, subject = nil, custom_module = nil)
            dynamic_info = self.dynamic_info
            module_name = custom_module || dynamic_info[:module_name]
            object_name = dynamic_info[:object_name]

            cloud_object.subscribers.where(action: action).each do |subscriber|
                case subscriber.notification_type
                when "email"
                    Courier::Bell::Notification::Email.new(
                        subscriber.user,
                        subject || action,
                        url: "#{module_name}/#{object_name}/#{cloud_object.id}",
                        category: "info"
                    )
                when "web"
                    Courier::Bell::Notification::Web.new(
                        subscriber.user,
                        subject || action,
                        url: "#{module_name}/#{object_name}/#{cloud_object.id}",
                        category: "info"
                    )
                end
            end
        end

=begin
@param cloud_object [ApplicationRecord] Cloud object to which an user can subscribe to
@param user [User] The user that is subscribing to the *cloud_object*
@return [Array] Array of subscriptions. There is one subscription per *action*.
@description Generates an array of subscription, Each element contains a subscription *action*, 
    information about wheter the *user* is subscribed or not and, if the user is subscribed, 
    the notification type of the subscription
@example
    ticket = CloudHelp::Ticket.find( 1 )
    subscription_actions = CloudHelp::Ticket::Subscriber.subscription_actions(
        ticket,
        current_user
    )
=end
        def self.subscription_actions(cloud_object, user)
            model = dynamic_info[:model]

            data = { }
            actions = model.actions.keys
            actions.each do |action|
                data[action] = {
                    action: action,
                    subscribed: false,
                    notification_type: :web
                }
            end
            cloud_object.subscribers.where(users_id: user.id).each do |subscriber|
                data[subscriber.action][:id] = subscriber.id
                data[subscriber.action][:subscribed] = true
                data[subscriber.action][:notification_type] = subscriber.notification_type
            end
            data.values
        end
    
        private

=begin
@return [Hash] Hash that contains information about the class
@description Returns dynamic information based on the current implementation of this abstract class
@example
    dynamic_info = CloudHelp::Ticket::Subscriber.dynamic_info
    puts dynamic_info[:module_name] # will print 'help'
    puts dynamic_info[:object_name] # will print 'ticket'
    dynamic_info.model.new # will return an instance of CloudHelp::Ticket::Subscriber
=end
        def self.dynamic_info
            module_info = self.lesli_classname().split("::")
            {
                module_name: module_info[0].sub("Cloud", "").downcase,
                object_name: module_info[1].downcase,
                model: "#{module_info[0]}::#{module_info[1]}::Subscriber".constantize
            }
        end

    end
end
