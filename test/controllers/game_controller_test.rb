require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test 'GET #new' do
    games_count_before = Game.all.size

    get :new, token: token

    games_count_after = Game.all.size

    game_resp = JSON.parse @response.body
    created_game = Game.find game_resp['id']

    player = Player.find_by_token token
    game_player = created_game.players.first

    assert_equal 1, games_count_after - games_count_before
    assert_equal player.id, game_player.id
  end

  test 'shoud return error when try to create a new game with invalid token' do
    get :new, token: invalid_token
    assert @response.success?, 'response failed'
    resp = JSON.parse @response.body
    assert_equal 'Unknown Token', resp['error'], 'Incorrect error msg'
  end

  test 'should not list games created by a player' do
    get :list, token: token, status: 'created'
    assert @response.success?, 'response failed'
    resp = JSON.parse @response.body

    resp.each do |game|
      game['players'].each do |p|
        assert_not_equal p['id'], 12345, 'game list contains games created by player with id= 12345'
      end
    end
  end

  test 'should list games created by a player' do
    get :list, status: 'created'
    assert @response.success?, 'response failed'
    resp = JSON.parse @response.body
    contains_players_game=false
    resp.each do |game|
      game['players'].each do |p|
        if p['id'] == 12345
          contains_players_game =true
        end
      end
    end

    assert contains_players_game, 'game list DOES NOT contain games created by player with id= 12345'
  end

  test 'shoud return error when try to place a ship on board with invalid token' do
    get :set, params_with_invalid_token
    assert @response.success?, 'response failed'
    resp = JSON.parse @response.body
    assert_equal 'Unknown Token', resp['error'], 'Incorrect error msg'
  end

  test 'GET #new - Board size should not be bigger than expected' do
    20.times do
      games_count_before = Game.all.size
      get :new, token: token
      games_count_after = Game.all.size
      game_resp = JSON.parse @response.body
      created_game = Game.find game_resp['id']
      assert_equal 1, games_count_after - games_count_before
      board_size = created_game.width * created_game.height
      assert board_size <= (GameController::MAX_NUMBER_OF_PIXELS + GameController::VARIABLE_SIZE * created_game.width), 'Game board is too big. Size=' + board_size.to_s + " W=" + created_game.width.to_s + " H=" + created_game.height.to_s
      assert board_size >= (GameController::MAX_NUMBER_OF_PIXELS - (1 + GameController::VARIABLE_SIZE) * created_game.width), 'Game board is too small. Size=' + board_size.to_s + " W=" + created_game.width.to_s + " H=" + created_game.height.to_s
    end
  end

  test 'should be able to join existing game and game status should be changed to "ready"' do
    get :join, id: 10, token: token_fred
    resp = JSON.parse @response.body
    assert @response.success?, 'unsuccessful response from GAME JOIN'
    assert_equal 'You joined the game with ID=10', resp['msg'], 'unexpected join game response'

    get :stats, id: 10
    resp = JSON.parse @response.body
    assert @response.success?, 'unsuccessful response from GAME SHOW'

    hasTwoPlayers = false
    assert_equal 2, resp['players'].length, 'number of players is not equal 2'
    assert_equal 'ready', resp['status'], 'Game status is wrong'

    resp['players'].each do |p|
      if p['id']== id_fred
        hasTwoPlayers = true
      end
    end
    assert hasTwoPlayers, 'unable to find a second player'
  end

  test 'shoud list the finished games' do
    get :list, status: 'end'
    resp = JSON.parse @response.body
    assert @response.success?, 'unsuccessful response from GAME STATUS'
    finished = Game.where status: 'end'
    assert_equal resp.length, finished.length, 'Incorrect number of finished games'
  end

  test 'shoud list the ongoing games' do
    get :list, status: 'fight'
    resp = JSON.parse @response.body
    assert @response.success?, 'unsuccessful response from GAME STATUS'
    finished = Game.where status: 'fight'
    assert_equal resp.length, finished.length, 'Incorrect number of ongoing games'
  end

  test 'shoud list the ready games' do
    get :list, status: 'ready'
    resp = JSON.parse @response.body
    assert @response.success?, 'unsuccessful response from GAME STATUS'
    finished = Game.where status: 'ready'
    assert_equal resp.length, finished.length, 'Incorrect number of ready games'
  end

  test 'should get error when joining non-existing game' do
    get :join, id: 666, token: token_fred
    resp = JSON.parse @response.body
    assert_equal 'Unable to find game', resp['error'], 'unexpected join game error response'
  end

  test 'should return error when requesting game status for non-existing game' do
    get :stats, id: 666
    assert @response.success?, 'unsuccessful response from GAME STATUS'
    resp = JSON.parse @response.body
    assert_equal 'Unable to find game', resp['error'], 'Incorrect error response'
  end

  test 'GET #new Create game and join a second player with a single request' do
    games_count_before = Game.all.size

    get :new, token: token, secondPlayerId: 12346

    games_count_after = Game.all.size

    game_resp = JSON.parse @response.body
    created_game = Game.find game_resp['id']

    player = Player.find_by_token token
    first_game_player = created_game.players.first
    second_game_player = created_game.players.second

    assert_equal 1, games_count_after - games_count_before, 'Game not created at all in db'
    assert_equal player.id, first_game_player.id, 'First player Id incorrect'
    assert_equal 12346, second_game_player.id, 'Second player ID incorrect'
  end


  test 'Should list all open games with status \'created\'' do
    get :list, status: 'created'
    resp = JSON.parse @response.body
    assert @response.success?, 'Game list failed'
    game = JSON.parse @response.body

    games_in_db = Game.where status: 'created'

    assert_equal game.length, games_in_db.size, 'Number of games doesn\'t mach whats in db'
  end

  test 'POST #set' do
    post :set, params

    first_ship_type = params[:ships][0][:type]

    player_board = current_player_board params

    assert_equal 1, player_board.ships.size

    assert_equal first_ship_type, player_board.ships.first.t.to_s
    assert_equal 3, player_board.ships.first.positions.size
  end

  test 'POST #set, multiple ships' do
    post :set, params_multiple

    player_board = current_player_board(params_multiple)

    assert_equal 18, player_board.ships.size
    assert_equal 3, player_board.ships.find_by(t: :submarine).positions.size
    assert_equal 2, player_board.ships.find_by(t: :patrol).positions.size
    assert_equal 5, player_board.ships.find_by(t: :carrier).positions.size
  end

  test 'GET #set, ship has to have right size' do
    post :set, params

    game = Game.find(params[:id])

    assert_equal 1, game.player_board(12345).ships.size
  end

  test 'user token is not returned in the SET request' do
    post :set, params

    resp = JSON.parse @response.body
    assert resp['players'][0]['token'].nil?,'User token is in the response'

  end

  test 'GET #shoot, {x, y}' do
    shoots_count_before = Shoot.all.size

    get :shoot, token: 'i_have_no_ships', id: 4, x: 1, y: 1

    shoots_count_after = Shoot.all.size
    assert_equal shoots_count_after, 1 + shoots_count_before
  end

  test 'should not be possible to shoot in bord in game that is not yours' do
    get :shoot, token: 'player_1_token', id: 4, x: 1, y: 1
    resp = JSON.parse @response.body
    assert_equal ['This is not your game'], resp['error'], 'Incorrect error message'
  end

  test 'should not be possible to set the same ship more than once' do
    get :new, token: token
    resp = JSON.parse @response.body
    gameId = resp['id']
    assert_not_nil gameId, 'Game ID not found'
    get :set, token: token, id: gameId, ships: [{
                                                    type: 'patrol',
                                                    xy: [0, 0],
                                                    variant: 0
                                                }]
    assert @response.success?, 'Set request Failed'
    resp = JSON.parse @response.body

    assert resp['error'].nil?, 'Unexpected an error message'

    get :set, token: token, id: gameId, ships: [{
                                                    type: 'patrol',
                                                    xy: [10, 10],
                                                    variant: 0
                                                }]
    assert @response.success?, 'Set request Failed'
    resp = JSON.parse @response.body

    assert_equal 'your ship CAN NOT be placed on the board. It collides with others or is out of the board', resp['error'], 'Incorrect error message'
  end


  test 'should get an error msg when issue an incorrect SET request' do
    get :new, token: token
    resp = JSON.parse @response.body
    gameId = resp['id']
    assert_not_nil gameId, 'Game ID not found'
    get :set, token: token, id: gameId

    assert @response.success?, 'Set request Failed'
    resp = JSON.parse @response.body
    assert_equal '\'ships\' param is missing', resp['error'], 'Unexpected an error message'
  end


  test 'should not be possible to set ship in non-existing variant' do
    get :new, token: token
    resp = JSON.parse @response.body
    gameId = resp['id']
    assert_not_nil gameId, 'Game ID not found'
    get :set, token: token, id: gameId, ships: [{
                                                    type: 'patrol',
                                                    xy: [10, 10],
                                                    variant: 4
                                                }]
    assert @response.success?, 'Set request Failed'
    resp = JSON.parse @response.body
    assert_equal 'patrol ship type in variant 4 is not allowed', resp['error'], 'Expected an error message'
  end

  test 'should not be possible to set undefined ship type' do
    get :new, token: token
    resp = JSON.parse @response.body
    gameId = resp['id']
    assert_not_nil gameId, 'Game ID not found'
    get :set, token: token, id: gameId, ships: [{
                                                    type: 'unknown',
                                                    xy: [10, 10],
                                                    variant: 0
                                                }]
    assert @response.success?, 'Set request Failed'
    resp = JSON.parse @response.body
    assert_equal 'unknown ship type is not allowed', resp['error'], 'Expected an error message'
  end

  test 'game is finished if it\'s status is "finished"' do
    game = Game.create({width: 5, height: 5})

    #game is not finishe if it's in state any other than fight/or finished

    assert_equal false, game.finished?

    game.status = 'ready'

    assert_equal false, game.finished?


    #game should be finished if it's status is 'finished'
    game.status = 'finished'
    assert_equal true, game.finished?
  end

  test 'game is finished if both players shoot all their shoots' do
    game = Game.create({width: 2, height: 2})
    p1 = Player.create({name: 'Bob'})
    p2 = Player.create({name: 'Frank'})

    game.players.push p1
    game.players.push p2
    game.status = 'fight'

    p1_board = game.boards.first
    p2_board = game.boards.last

    p1_board.ships.push Ship.new({t: 'cruiser'})
    p2_board.ships.push Ship.new({t: 'cruiser'})

    (0..1).each do |i|
      (0..1).each do |j|
        p1_shoot = Shoot.new({x: i, y: j, player_id: p1.id})
        p1_board.shoots.push p1_shoot

        p2_shoot = Shoot.create({x: i, y: j, player_id: p2.id})
        p2_board.shoots.push p2_shoot
      end
    end

    assert_equal true, game.finished?
  end

  private

  def current_player_board(params)
    current_player = assigns :current_player
    game = Game.find params[:id]
    game.player_board current_player.id
  end

  def params
    {
        token: token, #current player token
        id: 2, #game id
        ships: [{
                    type: 'submarine', #type of the boat
                    xy: [1, 1], #position of the boat (we assume game size is 10x10)
                    variant: 0
                }]
    }
  end

  def params_with_invalid_token
    {
        token: invalid_token,
        id: 2, #game id
        ships: [{
                    type: 'submarine', #type of the boat
                    xy: [1, 1], #position of the boat (we assume game size is 10x10)
                    variant: 0
                }]
    }
  end

  def params_multiple
    ships = []
    offset= 0
    ShipModels::SHIP_MODELS.each do |t, st|
      ships.push ({
          type: t.to_s,
          xy: [offset, 1],
          variant: 0
      })
      offset += 10
    end

    {
        token: 'fpq3hjf-q39jhg-q304hgr20',
        id: 5,
        ships: ships
    }
  end

end 