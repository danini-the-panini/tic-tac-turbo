require "test_helper"

class GameTest < ActiveSupport::TestCase
  test ".joinable_by scope" do
    assert_includes Game.joinable_by(players(:two)), games(:waiting_one)
    assert_includes Game.joinable_by(players(:one)), games(:waiting_two)

    refute_includes Game.joinable_by(players(:one)), games(:waiting_one)
    refute_includes Game.joinable_by(players(:two)), games(:waiting_two)

    refute_includes Game.joinable_by(players(:one)), games(:in_progress)
    refute_includes Game.joinable_by(players(:two)), games(:in_progress)
    refute_includes Game.joinable_by(players(:three)), games(:in_progress)
  end

  test "#joinable_by?" do
    assert games(:waiting_one).joinable_by?(players(:two))
    assert games(:waiting_two).joinable_by?(players(:one))

    refute games(:waiting_one).joinable_by?(players(:one))
    refute games(:waiting_two).joinable_by?(players(:two))

    refute games(:in_progress).joinable_by?(players(:one))
    refute games(:in_progress).joinable_by?(players(:two))
    refute games(:in_progress).joinable_by?(players(:three))
  end
end
