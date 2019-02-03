# Hard Sudoku Solver - https://www.codewars.com/kata/55171d87236c880cea0004c6
# Write a function that will solve a 9x9 Sudoku puzzle. The function will take one argument consisting of the 2D puzzle array, with the value 0 representing an unknown square.
# The Sudokus tested against your function will be "insane" and can have multiple solutions. The solution only need to give one valid solution in the case of the multiple solution sodoku.
# It might require some sort of brute force.

class Sudoku
  def initialize(puzzle)
    @puzzle = puzzle.flatten
  end

  def self.valid_puzzle?(puzzle)
    return false unless puzzle.size == 9
    return false unless puzzle.all?{|row| row.size == 9}
    return false unless puzzle.all?{|row| valid_puzzle_row?(row)}
    return false unless puzzle.transpose.all?{|row| valid_puzzle_row?(row)}
    return false unless puzzle.map.with_index{|r, a| r.map.with_index{|e, b| puzzle[(a/3)*3 + b/3][(a%3)*3 + b%3]}}.all? {|row| valid_puzzle_row?(row)}
    return false unless puzzle.flatten.select{|e| e > 0}.size >= 17
    return false unless puzzle.flatten.select{|e| e > 0}.uniq.size >= 8
    return true
  end

  def self.valid_puzzle_row?(row)
    nums = row.select{|e| e > 0}
    (row.min >= 0 && row.max <= 9 && nums.uniq.size == nums.size)
  end

  def possible_values(idx)
    (1..9).to_a - (@puzzle[(idx/9)*9, 9] + @puzzle.each_slice(9).map{|row| row[idx%9]} +
      @puzzle[(idx/27)*27, 27].each_slice(9).map{|row| row[((idx%9)/3)*3, 3]}.flatten)
  end

  def next_cell
    arr = @puzzle.map.with_index{|value, idx| value == 0 ? possible_values(idx).size : 10}
    arr.index(arr.min)
  end

  def test_possibility
    begin
      found = false
      idx = 0
      while idx < @puzzle.size
        if @puzzle[idx] == 0
          possibilities = possible_values(idx)
          return false if possibilities.empty?
          if possibilities.size == 1
            @puzzle[idx] = possibilities[0]
            found = true
          end
        end
        idx += 1
      end
    end while found
    return true
  end

  def solved?
    !@puzzle.include?(0)
  end

  def solve
    return true if solved?

    saved = @puzzle.dup
    if test_possibility
      return true if solved?
      idx = next_cell
      values = possible_values(idx)
      values.each do |value|
        @puzzle[idx] = value
        return true if solve
      end
    end

    @puzzle = saved
    return false
  end

  def puzzle
    @puzzle.each_slice(9).to_a
  end
end

def solve(puzzle)
  puts "Puzzle is not valid!" unless Sudoku.valid_puzzle?(puzzle)
  sudoku = Sudoku.new(puzzle)
  puts "Puzzle is not solved!" unless sudoku.solve
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

p solve(puzzle)
