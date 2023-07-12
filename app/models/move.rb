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

  def position
    [
      'top left',
      'top middle',
      'top right',
      'middle left',
      'dead center',
      'middle right',
      'bottom left',
      'bottom middle',
      'bottom right'
    ][index]
  end

  private

    def player_in_game
      return unless player_id
      return if player_id == game.player_x_id
      return if player_id == game.player_o_id

      errors.add(:player, 'is not playing')
    end

    def game_in_progress
      return unless game
      return if game.in_progress?

      errors.add(:game, 'is not in progress')
    end

    def player_turn
      return unless game && player_id
      return if player_id == game.turn_player_id

      errors.add(:player, 'must wait their turn')
    end

    def valid_move
      return unless game && index
      return unless game.board[index]

      errors.add(:index, 'is occupied')
    end
end
