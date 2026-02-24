# app/controllers/garden_plots_controller.rb
class GardenPlotsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plot

  def plant
  plant = Plant.find(params[:plant_id])

  @plot.plant = plant
  if @plot.save
    render json: { success: true, plant_name: plant.common_name }
  else
    render json: { success: false, error: @plot.errors.full_messages.join(", ") }
  end
end

  private

  def set_plot
    @plot = GardenPlot.find(params[:id])
    # Optional: verify that current_user owns this plot
    redirect_to dashboard_path, alert: "Unauthorized" unless @plot.garden.user == current_user
  end
end
