class GardenPlotsController < ApplicationController
  before_action :authenticate_user!

  def update
    @garden_plot = GardenPlot.find(params[:id])
    @plant = Plant.find(params[:plant_id])

    if @garden_plot.update(plant: @plant)
      redirect_to @garden_plot.garden, notice: "Garden plot updated successfully."
    else
      redirect_to @garden_plot, alert: @garden_plot.errors.full_messages.join(", ")
    end
  end

  def edit
    @garden_plot = GardenPlot.find(params[:id])
    @available_plants = Plant.all
  end

  def show
    @plot = GardenPlot.find(params[:id])
    @plants = Plant.all
  end 

  def plant
    @plot = GardenPlot.find(params[:id])
    @plot.update(plant_id: params[:plant_id])

    redirect_to @plot, notice: "Plant added to the garden plot!"
  end
end
