class Game < ApplicationRecord
  belongs_to :player_x, class_name: 'Player', optional: true
  belongs_to :player_o, class_name: 'Player', optional: true

  validates :player_x, :player_o, presence: true, unless: :waiting?

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

  def joinable_by?(player)
    return false unless waiting?

    player_x != player && player_o != player
  end

end
