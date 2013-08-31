class ShootController < ApplicationController
  include TokenFilter

  def new
    me = Shoot.create do |s|
      s.player_id= Player.find_by_token(params[:token]).id
      s.x= params[:x]
      s.y= params[:y]
      Game.find(params[:game]).boards.each do |b|
        if b.player_id != s.player_id
          s.board_id= b.__id__
        end

      end

    end

    render json: me, status: :created
  end
end