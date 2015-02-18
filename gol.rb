class GameOfLife
  attr_accessor :board
  ALIVE = 1
  DEAD = 0

  def initialize board_size=3
    @board = init_board board_size
    @board = add_life @board
  end

  def init_board board_size
    b = []
    board_size.times do
      row = []
      board_size.times do
        row << 0
      end
      b << row
    end
    b
  end

  def add_life board
    board.map do |row|
      row.map do |element|
        rand 2
      end
    end
  end

  def neighbor_count row, col
    count = 0
    if col > 0
      col_start = col - 1
    else
      col_start = col
    end
    if col < @board.length-1
      col_end = col + 1
    else
      col_end = col
    end
    # previous row
    if row > 0
      count += @board[row-1][col_start..col_end].reduce(&:+)
    end
    # current row
    count += @board[row][col_start] + @board[row][col_end]
    # next row
    if row < @board.length-1
      count += @board[row+1][col_start..col_end].reduce(&:+)
    end
    count
  end

  def tick
   @board = @board.each_with_index.map do |row,i|
     row.each_with_index.map do |element,j|
       if element == ALIVE
         case neighbor_count(i,j)
         when 0..1
           DEAD
         when 2..3
           ALIVE
         when 3..8
           DEAD
         end
       else
         if neighbor_count(i,j) == 3
           ALIVE
         else
           DEAD
         end
       end
     end
   end
  end

  def display io=$stdout
    board.each do |row|
      row.each do |element|
        io.print " #{element == DEAD ? ' ' : '.' } "
      end
      io.print "\n"
    end
    io.puts "===" * @board.length
  end

  def run
    loop do
      tick
      display
      sleep 0.1
    end
  end
end

if __FILE__ == $0
  GameOfLife.new(20).run
end
