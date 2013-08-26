module GameHelper
  def find_and_render
    game = Game.find(params[:id])
    yield game
    render json: game.to_json( include: [:players, :boards])
  end
end