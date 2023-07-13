class MovesController < ApplicationController

  before_action :authenticate_player

  def create
    @move = game.moves.new(player: current_player, **permitted_params)

    if @move.perform
      game.broadcast_update_to_other_player(current_player)
      redirect_to game
    else
      redirect_to game, alert: 'Invalid move'
    end
  end

  def index
    @moves = game.moves.order(created_at: :asc)
  end

  private

    def game
      @game ||= current_player.games.find(params[:game_id])
    end

    def permitted_params
      params.require(:move).permit(:index)
    end

end
