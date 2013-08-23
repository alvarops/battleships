class GameController < ApplicationController
    include TokenFilter

    def new 
        game = Game.create
        game.players.push Player.find_by_token(params[:token])
        game.status = 'created'
        game.save

        render json: game

    end 

end 