# easy sudoku solver - https://www.codewars.com/kata/5296bc77afba8baa690002d7
# Write a function that will solve a 9x9 Sudoku puzzle. The function will take one argument consisting of the 2D puzzle array, with the value 0 representing an unknown square.

class Sudoku
  def initialize(puzzle)
    @puzzle = puzzle
  end

  def solve
    return true if solved?

    row, col = next_cell
    values = possible_values(row, col)

    until values.empty?
      @puzzle[row][col] = values.pop
      return true if solve
    end

    @puzzle[row][col] = 0
    return false
  end

  def puzzle
    @puzzle
  end

  def solved?
    !@puzzle.any?{|row| row.include?(0)}
  end

  private

  def possible_values(row, col)
    (1..9).to_a - (@puzzle[row] + @puzzle.map{|r| r[col]} + @puzzle.slice((row/3) * 3, 3).map{|r| r[(col/3)*3..(col/3)*3 + 2]}.flatten).uniq
  end

  def next_cell
    idx = @puzzle.flatten.index(0)
    [idx/9, idx%9]
  end

end

def sudoku(puzzle)
  sudoku = Sudoku.new(puzzle)
  sudoku.solve
  sudoku.puzzle
end

# test
puzzle = [[5,3,0,0,7,0,0,0,0],
          [6,0,0,1,9,5,0,0,0],
          [0,9,8,0,0,0,0,6,0],
          [8,0,0,0,6,0,0,0,3],
          [4,0,0,8,0,3,0,0,1],
          [7,0,0,0,2,0,0,0,6],
          [0,6,0,0,0,0,2,8,0],
          [0,0,0,4,1,9,0,0,5],
          [0,0,0,0,8,0,0,7,9]]

p sudoku(puzzle)
