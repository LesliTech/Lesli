class UsersController < ApplicationLesliController

    def index
        respond_to do |format|
            format.json {
                responseWithSuccessful(current_user.account.users)
            }
        end
    end

    def show
        respond_to do |format|
            format.json {
                responseWithSuccessful(current_user.account.users.find(params[:id]))
            }
        end
    end

end
