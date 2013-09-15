class ErrorController < ApplicationController
  def show
    render json: params[:error]
  end
end