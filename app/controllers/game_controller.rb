class GameController < ApplicationController
  include TokenFilter

  def new
    game = Game.create
    game.players.push Player.find_by_token(params[:token])
    game.status = 'created'
    game.save

    render json: game
  end

  def list
    games = Game.where status: 'created'

    render json: games
  end

  def stats
    game = Game.find(params[:id])

    render json: game.to_json( include: [:players, :boards])
  end

end 