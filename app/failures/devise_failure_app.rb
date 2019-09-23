class DeviseFailureApp < Devise::FailureApp

    def redirect_url
        login_path(:subdomain => 'secure')
    end

    # respond to eliminate recall
    def respond

        if http_auth?
            http_auth
        else
            redirect
        end

    end 

end
