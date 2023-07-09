class Board

  def initialize(game)
    @game = game
  end

  def cells
    @game.board_data
         .each_char
         .map { parse(_1) }
  end

  def [](index)
    parse(@game.board_data[index])
  end

  def []=(index, value)
    raise ArgumentError, 'value must be symbol' unless Symbol === value
    raise ArgumentError, 'value must be x or o' unless value.in?(%i[x o])

    @game.board_data[index] = value.to_s
  end

  def rows
    cells.each_slice(3)
  end

  def cols
    [0,3,6,1,4,7,2,5,8].map { cells[_1] }.each_slice(3)
  end

  def diags
    [0,4,8,2,4,6].map { cells[_1] }.each_slice(3)
  end

  def rows_with_index
    cells.each_with_index.each_slice(3)
  end

  def winner
    return :x if winner?(:x)
    return :o if winner?(:o)

    nil
  end

  def winner?(c)
    return true if rows.any?  { |r| r.all? { _1 == c } }
    return true if cols.any?  { |r| r.all? { _1 == c } }
    return true if diags.any? { |r| r.all? { _1 == c } }

    false
  end

  def draw?
    full? && !winner
  end

  def full?
    cells.none?(&:nil?)
  end

  private

    def parse(c)
      return c.to_sym if /[xo]/.match?(c)

      nil
    end

end
