class PlayersController < ApplicationController
  def new
    @player = Player.new
  end

  def create
    @player = Player.find_or_initialize_by(permitted_params)

    if @player.save
      session[:player_id] = @player.id
      redirect_to games_path, notice: "Welcome, #{@player.name}"
    else
      render :new, alert: "Oops, try again"
    end
  end

  def index
    @players = Player.where.not(id: current_player.id).order(name: :asc)
  end

  private

    def permitted_params
      params.require(:player).permit(:name)
    end
end
