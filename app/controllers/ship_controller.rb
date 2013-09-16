class ShipController < ApplicationController
  def list
    render json: ShipShapes::SHIP_TYPES
  end
end
