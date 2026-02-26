class PlantsController < ApplicationController
  before_action :authenticate_user!

  def index
    @plants = Plant.all
    @garden_plot_id = params[:garden_plot_id]
  end 

  
end
