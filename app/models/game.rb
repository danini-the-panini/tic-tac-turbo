class Game < ApplicationRecord
  belongs_to :player_x, class_name: 'Player', optional: true
  belongs_to :player_o, class_name: 'Player', optional: true

  has_many :moves, dependent: :destroy

  validates :player_x, :player_o, presence: true, unless: :waiting?
  validates :board_data, format: { with: /[ xo]{9}/ }

  enum :status, %i[
    waiting
    x_turn o_turn
    x_wins o_wins
    draw
  ]

  scope :in_progress, -> { where(status: %i[x_turn o_turn]) }
  scope :ended,       -> { where(status: %i[x_wins o_wins draw]) }
  scope :not_ended,   -> { where(status: %i[waiting x_turn o_turn]) }

  scope :other_in_progress, -> (player) {
    in_progress.where.not(player_x: player).where.not(player_o: player)
  }

  scope :joinable_by, -> (player) {
    waiting.merge(
      Game.where.not(player_x: player).where.not(player_x: nil)
        .or(Game.where.not(player_o: player).where.not(player_o: nil))
    )
  }

  def turn_player
    return player_x if x_turn? || x_wins?
    return player_o if o_turn? || o_wins?

    nil
  end

  def turn_player_id
    return player_x_id if x_turn? || x_wins?
    return player_o_id if o_turn? || o_wins?

    nil
  end

  def player_value(player)
    return :x if player.id == player_x_id
    return :o if player.id == player_o_id
  end

  def end_turn!
    return x_wins! if board.winner?(:x)
    return o_wins! if board.winner?(:o)
    return draw!   if board.draw?
    
    return x_turn! if o_turn?
    return o_turn! if x_turn?
  end

  def joinable_by?(player)
    return false unless waiting?

    player_x_id != player.id && player_o_id != player.id
  end

  def in_progress?
    x_turn? || o_turn?
  end

  def ended?
    x_wins? || o_wins? || draw?
  end

  def board
    @board ||= Board.new(self)
  end

  def status_message(player)
    case status
    when 'waiting'          then 'Waiting for players...'
    when 'x_turn', 'o_turn' then turn_message(player)
    when 'x_wins', 'o_wins' then win_message(player)
    when 'draw'             then 'Draw!'
    end
  end

  def turn_message(current_player)
    return 'Your turn' if current_player.id == turn_player_id

    "#{turn_player.name}'s turn"
  end

  def win_message(current_player)
    return 'You won!' if current_player.id == turn_player_id

    "#{turn_player.name} won!"
  end

  def c
    return :x if x_turn? || x_wins?
    return :o if o_turn? || o_wins?
    :none
  end

end
