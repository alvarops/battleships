class PlayerController < ApplicationController

  def new
    me = Player.create do |p|
      p.name = params[:name] || 'Anonymous'
    end

    render json: me, status: :created
  end

  def stats
    render json: Player.find(params[:id]).to_json(:except => [:token])
  end

  def my_stats
    token = params[:token]
    player = Player.find_by_token(token)
    if player.nil?
      render json: {error: 'Unknown Token'}
      return
    end
    render json: player
  end

  def list
    if params[:showToken] #just don't tell anyone
      render json: Player.all.to_json
    else
      render json: Player.all.to_json(:except => [:token])
    end
  end
end
