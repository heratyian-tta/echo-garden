class PlantsController < ApplicationController
  before_action :authenticate_user!

  def autocomplete
    term = params[:term].to_s.strip
    sunlight = params[:sunlight]

    plants = Plant.where("common_name ILIKE ?", "%#{term}%")
    # Filter by sunlight if needed
    if sunlight.present?
      plants = plants.where("light_requirements = ? OR light_requirements IS NULL", sunlight)
    end

    render json: plants.limit(10).pluck(:id, :common_name)
  end

  def search
    @plants = Plant
                .where("common_name ILIKE ?", "%#{params[:q]}%")
                .limit(10)

    render partial: "plants/search_results", locals: { plants: @plants }
  end
end
