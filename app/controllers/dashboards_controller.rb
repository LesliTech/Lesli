class DashboardsController < ApplicationController
    before_action :set_dashboard, only: [:show, :edit, :update, :destroy]

    def empty
    end

end
