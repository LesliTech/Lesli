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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class DriverMailer < ApplicationMailer

    # @return [void]
    # @param to [String] The address to which the email will be sent
    # @param subject [String] The subject of the e-mail
    # @param data [Hash] Information to substitute in the template. For this email, the params
    #       :name (the assigned user name), :title (event code, - last name of customer and city), and :href (the path of the event)
    # @description Sends an email informing the assigned user of a new event. The event is an instance of
    # CloudHouse::Project. Important: If the role of the creator is "student", the email must be sent to
    # werksstudenten@deutsche-leibrenten.de. Please check CloudHouse::ProjectsControler#send_email_notification_new
    # to see that verification
    def event_attendant_new(to, subject, data, template:"")
        data[:href] = "#{default_url_options[:host]}#{data[:href]}"
        
        event_template = IO.binread("#{Rails.root}/storage/keep/mails/event.ics")

        event_template = event_template
        .sub("{{organizer_name}}", data[:organizer_name].strip )
        .sub("{{organizer_email}}", data[:organizer_email].strip )
        .sub("{{dtstamp}}", data[:time_start].strftime("%Y%m%dT%H%M%S").strip )
        .sub("{{description}}",( data[:description] || "").strip )
        .sub("{{summary}}", ( data[:title] || "").strip )
        .sub("{{location}}", ( data[:location] || "").strip )
        .sub("{{dtstart}}", ( data[:time_start].strftime("%Y%m%dT%H%M%S")).strip )
        .sub("{{dtend}}", ( data[:time_end].strftime("%Y%m%dT%H%M%S")).strip )
        .sub("{{uid}}", Time.now.getutc.to_s)
        .sub("{{url}}", URI.escape(data[:href]) )

        data[:date] = Courier::Core::Date.to_string(data[:time_start])
        data[:time_start] = Courier::Core::Date.to_string_time(data[:time_start])
        data[:time_end] = Courier::Core::Date.to_string_time(data[:time_end])

        attachments["crm_event.ics"] = event_template
        
        send(to, subject, data, template:"")
    end
end
