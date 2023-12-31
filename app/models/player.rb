class Player < ApplicationRecord

  has_many :x_games, class_name: 'Game', foreign_key: :player_x_id, dependent: :destroy
  has_many :o_games, class_name: 'Game', foreign_key: :player_o_id, dependent: :destroy

  def games
    x_games.or(o_games)
  end

  validates :name, presence: true, uniqueness: true

end
