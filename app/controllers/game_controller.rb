class GameController < ApplicationController
  include TokenFilter
  include GameHelper

  rescue_from ActiveRecord::RecordNotUnique, :with => :rescue_duplicate

  def new
    game = Game.create
    game.players.push Player.find_by_token(params[:token])
    game.status = 'created'
    if params[:secondPlayerId]
      game.players.push Player.find_by(id: params[:secondPlayerId])
      game.status = 'ready'
    end
    game.save
    #TODO: filter out player tokens
    render json: game.to_json(:include => [:players])
  end

  def list
    games = Game.where status: 'created'

    render json: games
  end

  def stats
    @game = Game.find(params[:id])


    render json: @game.to_json(:include => [:players, :boards => {:include => [:ships => {:include => [:positions]}]}])
  end

  def set
    find_and_render do |game|
      player_board = game.boards.find_by player_id: @current_player.id

      new_ships = params[:ships]

      new_ships.each do |new_ship|
        ship = Ship.new t: new_ship[:type]

        player_board.ships.push ship
        ship.save
        player_board.save
        #puts player_board.errors
      end
    end
  end

  def randomize
    game = Game.find(params[:id])
    board = game.boards.find_by(player_id: @current_player.id)
    board.randomize
    #TODO: filter out player tokens
    render json: game.to_json(:except => [:players])
  end

  def shoot
    shoot= Shoot.create do |s|
      s.player_id= @current_player.id
      s.x= params[:x]
      s.y= params[:y]
      Game.find(params[:id]).boards.each do |b|
        if b.player_id != s.player_id
          s.board_id= b.id
        end
      end
    end

    if shoot.save
      positions = Array.new
      shoot.board.ships.each do |s|
        s.positions.all? { |p| positions.push p }
      end
      found = nil

      positions.each do |p|
        if p.x == shoot.x && p.y == shoot.y
          found = p
          p.hit = true
          p.save
        end
      end

      if !found.nil?
        render json: {x: shoot.x, y: shoot.y, ship_type: found.ship.t, ship_status: found.ship.status}, status: :created
      else
        render json: shoot, status: :not_found #shoot.to_json(:except => [:boards]), status: :not_found
      end
    else
      render json: shoot.errors, status: :ok
    end
  end

  protected
  def rescue_duplicate
    render json: {:error => ['Duplicate record']}, :status => :ok
  end

end 