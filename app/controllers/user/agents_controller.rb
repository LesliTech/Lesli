=begin
Copyright (c) 2023, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end
class User::AgentsController < ApplicationController
    before_action :set_user_agent, only: [:show, :update, :destroy]

    # GET /user/agents
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(User::Agent.index(current_user, @query))
            end
        end
    end

    # GET /user/agents/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @user_agent
                return respond_with_successful(@user_agent.show(current_user, @query))
            end
        end
    end

    # GET /user/agents/new
    def new
    end

    # GET /user/agents/1/edit
    def edit
    end

    # POST /user/agents
    def create
        user_agent = User::Agent.new(user_agent_params)
        if user_agent.save
            respond_with_successful(user_agent)
        else
            respond_with_error(user_agent.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /user/agents/1
    def update
        return respond_with_not_found unless @user_agent

        if @user_agent.update(user_agent_params)
            respond_with_successful(@user_agent.show(current_user, @query))
        else
            respond_with_error(@user_agent.errors.full_messages.to_sentence)
        end
    end

    # DELETE /user/agents/1
    def destroy
        return respond_with_not_found unless @user_agent

        if @user_agent.destroy
            respond_with_successful
        else
            respond_with_error(@user_agent.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_agent
        @user_agent = current_user.account.user_agents.find_by_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_agent_params
        params.require(:user_agent).permit(:id, :name)
    end
end
