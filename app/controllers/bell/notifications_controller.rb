class Bell::NotificationsController < ApplicationController
    before_action :set_bell_notification, only: [:show, :edit, :update, :destroy]

    # GET /bell/notifications
    def index
        bell_notifications = current_user.notifications.where(read: false)
        respond_to do |format|
            format.html { @bell_notifications = bell_notifications }
            format.json { responseWithSuccessful(bell_notifications) }
        end
    end

    # GET /bell/notifications/1
    def show
    end

    # GET /bell/notifications/new
    def new
        @bell_notification = Bell::Notification.new
    end

    # GET /bell/notifications/1/edit
    def edit
    end

    # POST /bell/notifications
    def create
        @bell_notification = Bell::Notification.new(bell_notification_params)

        if @bell_notification.save
            redirect_to @bell_notification, notice: 'Notification was successfully created.'
        else
            render :new
        end
    end

    # PATCH/PUT /bell/notifications/1
    def update
        if @bell_notification.update(bell_notification_params)
            redirect_to @bell_notification, notice: 'Notification was successfully updated.'
        else
            render :edit
        end
    end

    # DELETE /bell/notifications/1
    def destroy
        @bell_notification.destroy
        redirect_to bell_notifications_url, notice: 'Notification was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_bell_notification
        @bell_notification = Bell::Notification.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bell_notification_params
        params.fetch(:bell_notification, {})
    end
end
