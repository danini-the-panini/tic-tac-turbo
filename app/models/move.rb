class Move < ApplicationRecord
  belongs_to :game
  belongs_to :player

  validates :index, numericality: { only_integer: true, in: 0..9 }

  validate :player_in_game
  validate :game_in_progress
  validate :player_turn
  validate :valid_move

  after_commit :perform
  before_update { throw :abort }

  def value
    return :x if player == game.player_x
    return :o if player == game.player_o
  end

  def perform
    transaction do
      save!
      game.board[index] = value
      game.end_turn!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

    def player_in_game
      return unless player
      return if player == game.player_x
      return if player == game.player_o

      errors.add(:player, 'is not playing')
    end

    def game_in_progress
      return unless game
      return if game.in_progress?

      errors.add(:game, 'is not in progress')
    end

    def player_turn
      return unless game && player
      return if player == game.turn_player

      errors.add(:player, 'must wait their turn')
    end

    def valid_move
      return unless game && index
      return unless game.board[index]

      errors.add(:index, 'is occupied')
    end
end
