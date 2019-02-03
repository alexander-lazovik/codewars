# Fluent Calculator - https://www.codewars.com/kata/52a1feca5ec9c508d10006f8
# The goal is to implement simple calculator which uses fluent syntax:
# Calc.new.one.plus.two             # Should return 3
# Calc.new.five.minus.six           # Should return -1
# Calc.new.seven.times.two          # Should return 14
# Calc.new.nine.divided_by.three     # Should return 3
# There are only four operations that are supported (plus, minus, times, divided_by) and 10 digits (zero, one, two, three, four, five, six, seven, eight, nine).
# Each calculation consists of one operation only.

class Calc
  def method_missing(method, *args)
    digits = {zero: 0, one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9 }
    operators = {plus: :+, minus: :-, times: :*, divided_by: :/}
    if @first.nil?
      @first = digits[method]
      self unless @first.nil?
    elsif @operator.nil?
      @operator = operators[method]
      self unless @operator.nil?
    else
      second = digits[method]
#      return nil if second.nil? || @first.nil? || @operator.nil?
      @first.send(@operator, second) unless second.nil?
    end
  end
end

p Calc.new.one.plus.two             # Should return 3
p Calc.new.five.minus.six           # Should return -1
p Calc.new.seven.times.two          # Should return 14
p Calc.new.nine.divided_by.three     # Should return 3
