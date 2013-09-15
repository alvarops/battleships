class GameController < ApplicationController
  include TokenFilter
  include GameHelper

  rescue_from ActiveRecord::RecordNotUnique, :with => :rescue_duplicate

  MAX_NUMBER_OF_PIXELS = 800
  MAX_WIDTH = 80
  MIN_WIDTH=10
  VARIABLE_SIZE=1

  def new
    game = Game.create
    game.players.push Player.find_by_token(params[:token])
    game.width = Random.new.rand(MIN_WIDTH..MAX_WIDTH)
    max_height = MAX_NUMBER_OF_PIXELS / game.width
    game.height = Random.new.rand((max_height-VARIABLE_SIZE)..(max_height+VARIABLE_SIZE))
    game.status = 'created'
    if params[:secondPlayerId]
      game.players.push Player.find_by(id: params[:secondPlayerId])
      game.status = 'ready'
    end
    game.save
    render json: game.to_json(:include => {:players => {:except => :token}})
  end

  def list
    games = Game.where status: 'created'
    render json: games.to_json(:include => {:players => {:except => :token}})
  end

  def stats
    game = Game.find(params[:id])
    #TODO: exclude ship positions
    render json: game.to_json(:include => [:players, :boards => {:include => [:ships,:shoots] }])
    # render json: game.to_json(:include => [:players => {:except => :token}, :boards => {:include => :ships}])
    #render json: game.to_json(:include => {:players => {:except => :token},
    #                                       :boards  => {:include => {
    #                                           :ships => {
    #                                               :include => [:positions]
    #                                           },
    #                                           :shoots => {
    #                                               :include => [:x, :y]
    #                                           }
    #                                       }}})
  end

  def set
    find_and_render do |game|
      player_board = game.boards.find_by player_id: @current_player.id

      new_ships = params[:ships]

      new_ships.each do |new_ship|
        type = new_ship[:type]
        x = new_ship[:xy][0]
        y = new_ship[:xy][1]
        variant = new_ship[:variant]
        ship = Ship.set_on_board type, x, y, variant

        if player_board.can_place? ship
          player_board.ships.push ship
          player_board.save
        else
          redirect_to :error
          return
        end
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
    game = Game.find(params[:id])
    opponents_board = game.opponent_board @current_player.id

    if !opponents_board.nil? #is there is anything to shot at?

      shoot = create_shoot(opponents_board)

      if shoot.save
        render_shoot(shoot)
      else
        @out = {json: shoot.errors, status: :bad_request}
      end

    else
      @out = {json: {error: ['There is no opponent']}, status: :bad_request}
    end

    render json: @out[:json], status: @out[:status]

  end

  def show
    @game = Game.find(params[:id])
    @board = @game.boards.find_by(player_id: @current_player.id)
    @positions = []
    @board.ships.each do |s|
      s.positions.each do |p|
        @positions.push p
      end
    end
  end

  protected

  def rescue_duplicate
    render json: {:error => ['Duplicate record']}, :status => :ok
  end

  private

  def render_shoot(shoot)
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
      if found.ship.status==:sunk
        shoot.result='hitsunk'
      else
        shoot.result='hit'
      end
      shoot.save
      @out = {json: {x: shoot.x, y: shoot.y, ship_type: found.ship.t, ship_status: found.ship.status}, status: :created}
    else
      shoot.result= 'miss'
      shoot.save
      @out = {json: shoot, status: :not_found}
    end
  end

  def create_shoot(opponents_board)
    Shoot.create do |s|
      s.player_id = @current_player.id
      s.board_id = opponents_board.id
      s.x = params[:x]
      s.y = params[:y]
    end
  end

end
