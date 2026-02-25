class PlantsController < ApplicationController
  before_action :authenticate_user!

  def index
    @plants = Plant.all
  end 

  
end
