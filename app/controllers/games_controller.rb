class GamesController < ApplicationController

  before_action :authenticate_player

  def index
    @yours    = current_player.games.not_ended.order(updated_at: :desc)
    @joinable = Game.joinable_by(current_player).order(created_at: :asc)
    @other    = Game.other_in_progress(current_player).order(created_at: :asc)
    @ended    = Game.ended.order(updated_at: :desc)
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    is_x = [true, false].sample
    @game = Game.new(
      player_x: is_x ? current_player : nil,
      player_o: is_x ? nil : current_player
    )

    if @game.save
      redirect_to @game, notice: 'Game created!'
    else
      redirect_to games_path, alert: @game.errors.full_messages.to_sentence
    end
  end

  def join
    @game = Game.joinable_by(current_player).find(params[:id])

    if @game.player_x
      @game.player_o = current_player
    else
      @game.player_x = current_player
    end

    @game.status = :x_turn

    if @game.save
      redirect_to @game, notice: 'Joined game!'
    else
      redirect_to games_path, alert: @game.errors.full_messages.to_sentence
    end
  end

end
