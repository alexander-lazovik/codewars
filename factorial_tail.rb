# Factorial tail - https://www.codewars.com/kata/55c4eb777e07c13528000021
# How many zeroes are at the end of the factorial of 10? 10! = 3628800, i.e. there are 2 zeroes. 16! (or 0x10!) in hexadecimal would be 0x130777758000, which has 3 zeroes.
# Your task
# is to write a function, which will find the number of zeroes at the end of (number) factorial in arbitrary radix = base for larger numbers.
# base is an integer from 2 to 256
# number is an integer from 1 to 1'000'000
#
require 'prime'

def prime_divide_number(prime, number)
  k = Math::log(number, prime).to_i
  (1..k).map{|i| number/(prime**i)}.inject(:+) || 0
end

def zeroes(base, number)
  base.prime_division.map{ |(prime, exponent)| prime_divide_number(prime, number)/exponent }.min
end

#test
p zeroes(10, 10)
p zeroes(10, 1000)
