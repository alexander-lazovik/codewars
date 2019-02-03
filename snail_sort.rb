# Snail Sort https://www.codewars.com/kata/521c2db8ddc89b9b7a0000c1
# Given an n x n array, return the array elements arranged from outermost elements to the middle element, traveling clockwise.

# Rotate by -90:
# Method 1 :Transpose
# Reverse each column
# Method 2 :
# Reverse each row
# Transpose
def snail(array)
  r = []
  until array.size == 0 do
    r << array.shift
    array = array.map{|a| a.reverse}.transpose
  end
  r.flatten
end

#test
array = [[1,2,3],
         [4,5,6],
         [7,8,9]]

p snail(array)
