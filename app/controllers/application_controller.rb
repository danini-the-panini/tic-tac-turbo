class ApplicationController < ActionController::Base

  helper_method :current_player

  def current_player
    return @current_player if defined?(@current_player)

    @current_player = Player.find_by(id: session[:player_id])
  end

  def sign_in(player)
    @current_player = player
    session[:player_id] = player.id
  end

  def sign_out
    @current_player = nil
    session[:player_id] = nil
  end

  private

    def authenticate_player
      redirect_to new_player_path, alert: 'Who are you?' unless current_player
    end

end
