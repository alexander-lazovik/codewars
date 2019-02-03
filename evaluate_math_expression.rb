# Evaluate mathematical expression - https://www.codewars.com/kata/52a78825cdfc2cfc87000005
# Given a mathematical expression as a string you must return the result as a number.
# Numbers
# Number may be both whole numbers and/or decimal numbers. The same goes for the returned result.
# Operators
# You need to support the following mathematical operators:
# Multiplication *
# Division / (as true division)
# Addition +
# Subtraction -
# Operators are always evaluated from left-to-right, and * and / must be evaluated before + and -.
# Parentheses
# You need to support multiple levels of nested parentheses, ex. (2 / (2 + 3.33) * 4) - -6

def calc expression
  expr = expression.delete ' '
  nil while expr.sub!(/\(([^()]+)\)/){ calc $1 }
  nil while expr.sub!(/--/, ?+)
  nil while expr.sub!(/(-?[.\d]+)([*\/])\+?(-?[.\d]+)/){ $1.to_f.send $2, $3.to_f }
  nil while expr.sub!(/(-?[.\d]+)([-+])\+?(-?[.\d]+)/){ $1.to_f.send $2, $3.to_f }
  expr.to_f
end

# Test
tests = {
  "1"                            => 1,
  "1+1"                          => 2,
  "1 + 1"                        => 2,
  "1 - 1"                        => 0,
  "-1"                           => -1,
  "1 + -1"                       => 0,
  "1 - -1"                       => 2,
  "2*3+1"                        => 7,
  "1+2*3"                        => 7,
  "(1+2)*3"                      => 9,
  "(2+(3-4) *3 ) * -6 * ( 3--4)" => 42,
  "4*6/3*2"                      => 16,
  "10 / (2 + 3) * 4 + 6"      => 14
}

tests.each do |expr,expected|
  actual = calc expr
  puts "#{expr} = #{actual}" if actual == expected
  puts [expr.inspect, '=>', actual, 'instead of', expected].join(' ') unless actual == expected
end
