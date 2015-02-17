if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    command_name 'Minitest'
  end
end

require_relative "gol.rb"
require "minitest/autorun"
require "minitest/pride"

class GameOfLifeTest < Minitest::Test
  BOARD_SIZE = 3
  EMPTY_BOARD = [[0,0,0],[0,0,0],[0,0,0]]
  SIMPLE_BOARD = [[0,0,0],[0,1,0],[0,0,0]]
  GEN_1 = [[0,1,1],[1,1,0],[0,1,0]]
  GEN_2 = [[1,1,1],[0,0,0],[1,1,0]]
  GEN_3 = [[1,1,1],[0,0,1],[1,0,0]]

  DISPLAY_OUT = <<EOS
    .  . 
 .  .    
    .    
=========
EOS

  def setup
    @game = GameOfLife.new BOARD_SIZE
  end

  def test_init_board
    assert_equal EMPTY_BOARD, @game.init_board(BOARD_SIZE)
  end

  def test_add_life
    refute_equal EMPTY_BOARD, @game.add_life(EMPTY_BOARD)
  end

  def test_neighbor_count
    @game.board = SIMPLE_BOARD
    assert_equal 1, @game.neighbor_count(0,0)
    assert_equal 1, @game.neighbor_count(0,1)
    assert_equal 1, @game.neighbor_count(0,2)
    assert_equal 1, @game.neighbor_count(1,0)
    assert_equal 0, @game.neighbor_count(1,1)
    assert_equal 1, @game.neighbor_count(1,2)
    assert_equal 1, @game.neighbor_count(2,0)
    assert_equal 1, @game.neighbor_count(2,1)
    assert_equal 1, @game.neighbor_count(2,2)
  end

  def test_can_tick
    @game.board = GEN_1
    @game.tick
    assert_equal GEN_2, @game.board
    @game.tick
    assert_equal GEN_3, @game.board
  end

  def test_can_display
    @game.board = GEN_1
    io = StringIO.new
    @game.display io
    assert_equal DISPLAY_OUT, io.string
  end
end
