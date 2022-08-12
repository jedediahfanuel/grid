require "spec"
require "../src/grid"

def create_filled_object
  temp = Grid.new("a b c d e f g h j i k l m n o p q r s t u v w x y z")
  temp.virtual_generate
  temp.virtual_to_canvas
  return temp
end

def create_object_with_col(size : Int32) : Grid
  temp = Grid.new("")
  temp.col_width = Array(Int32).new(size, 0)
  return temp
end

def create_object_with_row(height : Int32) : Grid
  temp = Grid.new("")
  temp.col_height = Array(Int32).new(1, height)
  temp.col_height << (height - 1)
  return temp
end

def create_virtual_generate(str : String) : Grid
  return Grid.new(str)
end

def create_to_string(str : String)
  grid = Grid.new(str)
  grid.virtual_generate(18)
  grid.virtual_to_canvas
  grid.to_s(true)
end
