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
      if params[:showToken]
        render json: Player.all.to_json
      else
        render json: Player.all.to_json(:except => [:token])
      end
    end
end
