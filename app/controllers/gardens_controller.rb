class GardensController < ApplicationController
  before_action :authenticate_user!

  def index
    # Only show gardens for the current user
    @gardens = current_user.gardens
  end

  def show
    @garden = current_user.gardens.find(params[:id])
  end
end
