require "test_helper"

class BoardTest < ActiveSupport::TestCase
  setup do
    @game = games(:in_progress)
    @board = @game.board
  end

  test "#cells" do
    assert_equal [
      nil, nil,  :o,
      nil,  :x, nil,
      nil, nil, nil
    ], @board.cells

    @game.board_data = ' '*9
    assert_equal [
      nil, nil, nil,
      nil, nil, nil,
      nil, nil, nil
    ], @board.cells
  end

  test "#[]" do
    assert_nil @board[0]
    assert_nil @board[1]

    assert_equal :o, @board[2]
    assert_equal :x, @board[4]
  end

  test "#[]=" do
    @board[1] = :o

    assert_equal :o, @board[1]
    assert_equal 'o', @game.board_data[1]

    assert_raises { @board[1] = :X }
    assert_raises { @board[1] = 'x' }
  end

  test "#rows" do
    assert_equal [
      [nil, nil,  :o],
      [nil,  :x, nil],
      [nil, nil, nil]
    ], @board.rows.map(&:to_a).to_a
  end

  test "#cols" do
    assert_equal [
      [nil, nil, nil],
      [nil,  :x, nil],
      [:o,  nil, nil]
    ], @board.cols.map(&:to_a).to_a
  end

  test "#diags" do
    assert_equal [
      [nil, :x, nil],
      [:o,  :x, nil]
    ], @board.diags.map(&:to_a).to_a
  end

  test "#rows_with_index" do
    assert_equal [
      [[nil, 0], [nil, 1], [ :o, 2]],
      [[nil, 3], [ :x, 4], [nil, 5]],
      [[nil, 6], [nil, 7], [nil, 8]]
    ], @board.rows_with_index.map(&:to_a).to_a
  end

  test "#winner" do
    assert_nil @board.winner

    assert_winner :x, [
      'xxx',
      '   ',
      '   '
    ]
    assert_winner :x, [
      '   ',
      'xxx',
      '   '
    ]
    assert_winner :x, [
      'x  ',
      'x  ',
      'x  '
    ]
    assert_winner :x, [
      ' x ',
      ' x ',
      ' x '
    ]
    assert_winner :x, [
      'x  ',
      ' x ',
      '  x'
    ]
    assert_winner :x, [
      '  x',
      ' x ',
      'x  '
    ]
    assert_winner :o, [
      '  o',
      ' o ',
      'o  '
    ]
    assert_no_winner [
      'xox',
      'oxo',
      'oxo'
    ]
  end

  test "#draw?" do
    refute_predicate @board, :draw?

    assert_draw [
      'xox',
      'oxo',
      'oxo'
    ]
    refute_draw [
      '   ',
      'xxx',
      '   '
    ]
    refute_draw [
      'xoo',
      'xox',
      'oxx'
    ]
  end

  test "#full?" do
    refute_predicate @board, :full?

    assert_full [
      'xoo',
      'xox',
      'oxx'
    ]
    refute_full [
      'xoo',
      'xox',
      ' xx'
    ]
    refute_full [
      '   ',
      '   ',
      '   '
    ]
  end

  def assert_winner(c, board)
    @game.board_data = board.join
    assert_equal c, @board.winner
  end

  def assert_no_winner(board)
    @game.board_data = board.join
    assert_nil @board.winner
  end

  def assert_draw(board)
    @game.board_data = board.join
    assert_predicate @board, :draw?
  end

  def refute_draw(board)
    @game.board_data = board.join
    refute_predicate @board, :draw?
  end

  def assert_full(board)
    @game.board_data = board.join
    assert_predicate @board, :full?
  end

  def refute_full(board)
    @game.board_data = board.join
    refute_predicate @board, :full?
  end
end
