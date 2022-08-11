require "spec"
require "../src/grid"

def create_filled_object
  temp = Grid.new("a b c d e f g h j i k l m n o p q r s t u v w x y z")
  temp.virtual_generate
  temp.virtual_to_canvas
  return temp
end
