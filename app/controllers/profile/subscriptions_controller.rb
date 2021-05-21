class Profile::SubscriptionsController < ApplicationLesliController
  skip_before_action :authorize_request
  skip_before_action :authorize_privileges
  # TODO fix permissions and remove the skips

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

  # TODO should we not rather have update?
  def edit
  end
end
