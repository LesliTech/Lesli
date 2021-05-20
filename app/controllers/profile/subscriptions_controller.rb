class Profile::SubscriptionsController < ApplicationController
  def index
    subscriptions = DeutscheLeibrenten::Project::Subscriber.where(users_id: current_user.id)

    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful(subscriptions)
      end
    end
  end

  def destroy
  end

  def edit
  end
end
