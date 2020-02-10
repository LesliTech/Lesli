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
@description Manages password reset options for existing users

=end
class Users::PasswordsController < Devise::PasswordsController
    layout "application-public"

=begin
@controller_action_param :email [String] The registered user email
@return [Json] Json with a status response. It contains wheter the email 
    with information on how to reset the password was sent or not. 
    If it is not successful, it returs an error message
@description Sends an email with a token, so the user can reset their password
@example
    # Executing this controller's action from javascript's frontend
    let email = 'john.doe@email.com';
    let data = {
        user: {
            email: email
        }
    };
    this.http.post('127.0.0.1/password', data);
=end
    def create
        super do |resource|
            if successfully_sent?(resource)
                return responseWithSuccessful
            else
                return responseWithError(resource.errors.full_messages.to_sentence)
            end
        end
    end

=begin
@controller_action_param :password [String] The new password
@controller_action_param :password_confirmation [String] The password confirmation
@controller_action_param :reset_password_token [String] The token sent by this controller's *create* method
@return [Json] Json with a status response. It contains wheter the password was reset or not. 
    If it is not successful, it returs an error message
@description When the sends their new password along with the token sent by the *create* method,
    They can reset their password.
@example
    # Executing this controller's action from javascript's frontend
    let data = {
        user: {
            password: "my_new_password123",
            password_confirmation: "my_new_password123",
            reset_password_token: "123AWDq23WWer!@$23asd234sdfEaee5447"
        }
    };
    this.http.put('127.0.0.1/password', data);
=end
    def update
        super do |resource|
            if resource.errors.empty?
                return responseWithSuccessful
            else
                return responseWithError(resource.errors.full_messages.to_sentence)
            end
        end
    end
end
