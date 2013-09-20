class ShipController < ApplicationController
  def list
    render json: ShipModels::SHIP_MODELS
  end
end
