require "spec"
require "../src/grid"

def create_filled_object
  temp = Grid.new("a b c d e f g h j i k l m n o p q r s t u v w x y z")
  temp.virtual_generate
  temp.virtual_to_canvas
  return temp
end

def create_object_with_col(size : Int32)
  temp = Grid.new("")
  temp.col_width = Array(Int32).new(size, 0)
  return temp
end
