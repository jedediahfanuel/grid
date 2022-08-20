require "spec"
require "../src/grid"

def create_empty_grid
  return Grid.new()
end

def create_auto_top_down(str = "")
  x = Grid.new(str)
  x.auto(18, true)
  return x
end

def create_auto_top_down_with_custom_sep(str = "", sep = " ")
  x = Grid.new(str, sep)
  x.auto(18, true)
  return x
end

def create_auto_left_right(str = "")
  x = Grid.new(str)
  x.auto(18, false)
  return x
end

def create_auto_left_right_with_custom_sep(str = "", sep = " ")
  x = Grid.new(str, sep)
  x.auto(18, false)
  return x
end
