class GameController < ApplicationController
  include TokenFilter
  include GameHelper

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
    find_and_render {}
  end

  def set
    find_and_render do |game|
      player_board = game.boards.find_by player_id: @current_player.id

      new_ships = params[:ships]

      new_ships.each do |new_ship|
        ship = Ship.new
        ship.t = new_ship[:type]
        player_board.ships.push ship
        player_board.save
        puts player_board.errors
      end
    end
  end

  def randomize
    game = Game.find(params[:id])
    board = game.boards.find_by(player_id: @current_player.id)
    board.randomize
    render json: game
  end

end 