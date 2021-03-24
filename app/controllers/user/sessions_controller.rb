class User::SessionsController < ApplicationLesliController
    before_action :set_user_session, only: [:show, :edit, :update, :destroy]
    before_action :set_user, only: [:index]

    # GET /user/sessions
    def index
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @user
                return respond_with_successful(User::Session.index(@user, @query, session[:user_session_id]))
            end
        end
    end

    # GET /user/sessions/1
    def show
    end

    # GET /user/sessions/new
    def new
    end

    # GET /user/sessions/1/edit
    def edit
    end

    # POST /user/sessions
    def create
    end

    # PATCH/PUT /user/sessions/1
    def update
    end

    # DELETE /user/sessions/1
    def destroy
        return respond_with_not_found unless @user_session

        if @user_session.delete
            current_user.logs.create({ session_uuid: @user_session.session_uuid, title: "session_closing_successful", description: "closing session from session managements, session_id: #{@user_session.id.to_s} " })
            respond_with_successful
          else
            respond_with_error(@user_session.errors.full_messages.to_sentence)
        end
    end

    private
        # Use callbacks to share common setup or constraints between actions.
    def set_user_session
        @user_session = User::Session.find(params[:id])
    end

    def set_user
        @user = current_user.account.users.find(params[:user_id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_session_params
        params.require(:user_session).permit(:id,)
    end
end
