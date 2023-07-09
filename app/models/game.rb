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

  scope :joinable_by, -> (player) {
    waiting.merge(
      Game.where.not(player_x: player).where.not(player_x: nil)
        .or(Game.where.not(player_o: player).where.not(player_o: nil))
    )
  }

  def turn_player
    return player_x if x_turn?
    return player_o if o_turn?

    nil
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

    player_x != player && player_o != player
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

end
