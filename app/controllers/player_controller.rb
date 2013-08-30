class PlayerController < ApplicationController
    include TokenFilter
 
    def new
        me = Player.create do |p|
            p.name = params[:name] || 'Anonymous'            
        end

        render json: me, status: :created
    end

    def stats 
        render json: @current_player
    end 

    def list
      render json: Player.all
    end
end
