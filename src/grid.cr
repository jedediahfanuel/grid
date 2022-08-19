require "./top_down"
require "./left_right"

# `Grid` is a simple string grid formatter library for crystal programming language.
#
# Example:
#
# ```
# grid = Grid.new("Rubys Crystals Emeralds Sapphires a b") # Create a new Grid instance
#
# grid.virtual_generate(18, true) # generate top-down grid with 18 char as max canvas width
# grid.to_s(true) # get the string format (true) in top-down direction
# # Rubys    Sapphires
# # Crystals a        
# # Emeralds b        
#
# grid.virtual_generate(18, false) # generate left-right grid with 18 char as max canvas width
# grid.to_s(false) # get the string format (false) in left-right direction
# # Rubys    Crystals 
# # Emeralds Sapphires
# # a        b
#
# grid = Grid.new("Rubys Crystals Emeralds Sapphires a b", "|") # Create a new Grid instance with custom separator
# grid.virtual_generate(18, true) # generate left-right grid with 18 char as max canvas width
# grid.to_s(true, false) # get the string format (true) in top-down direction (false) align-right
# #    Rubys|Sapphires
# # Crystals|        a
# # Emeralds|        b
# ```
struct Grid
  VERSION = "0.1.1"

  # Holds the max width of the canvas.
  # Its defined by the user.
  # Default value is `24`.
  property max_width = 0

  # Holds the list of String from the user.
  #
  # Example:
  # ```
  # grid = grid.new("str_1 str_2 str_3")
  # grid.list # => ["str_1", "str_2", "str_3"]
  # ```
  getter list : Array(String)
  
  # Set the list from a string.
  #
  # Example:
  # ```
  # grid = grid.new("")
  # grid.list = "str_1 str_2 str_3"
  # grid.list # => ["str_1", "str_2", "str_3"]
  # ```
  def list=(str : String)
    @list = str.strip.split
  end
  
  # Set the list from an Array().
  #
  # Example:
  # ```
  # grid = grid.new("")
  # grid.list = ["str_1", "str_2", "str_3"]
  # grid.list # => ["str_1", "str_2", "str_3"]
  # ```
  def list=(@list : Array(String))
  end
  
  # Holds the separator specified by the user.
  # Default " " (a single space)
  getter separator = " "

  # Initialize grid *list* with type of `Array(String)` as a input parameter.
  # Example:
  #
  # ```
  # grid = Grid.new(["Ruby", "Crystal", "Emerald", "Sapphire"])
  # grid = Grid.new() # produce empty string
  # grid = Grid.new(["Ruby", "Crystal", "Emerald", "Sapphire"], " | ") # with custom separator
  # ```
  def initialize(@list : Array(String), @separator = " ")
  end

  # Initialize grid *list* with type of `String` as a input parameter.
  #
  # Example:
  # ```
  # grid = Grid.new("Ruby Crystal Emerald Sapphire")
  # grid = Grid.new() # produce empty list
  # grid = Grid.new("Ruby Crystal Emerald Sapphire", " | ") # with custom separator
  # ```
  def initialize(str = "", @separator = " ")
    @list = str.strip.split
  end

  include LeftRight
  include TopDown

  # Count the delimiter of specified column count.
  #
  # Example:
  # ```
  # delimiter_count_of(3) # => 2
  # delimiter_count_of(7) # => 6
  # ```
  def delimiter_count_of(col_count : Int32) : Int32
    col_count < 1 ? 0 : col_count - 1
  end

  # Convert all elements in *canvas* to a single string using `String#build`.
  # The first parameter *top_down* default is true.
  # The second parameter *align_left* default is true.
  # The third parameter *separator* default is ' ' (single space) || it follows the separator specified from `virtual_generate`.
  #
  # Example:
  #
  # ```
  # grid = Grid.new("Rubys Crystals Emeralds Sapphires a b") # Create a new Grid instance
  #
  # grid.virtual_generate(18, true) # generate top-down grid with 18 char as max canvas width
  # # => [["Rubys", "Crystals", "Emeralds"], ["Sapphires", "a", "b"]]
  #
  # grid.to_s(true) # get the string format (true) in top-down direction
  # # Rubys    Sapphires
  # # Crystals a        
  # # Emeralds b        
  #
  # grid.to_s(true, false)
  # #    Rubys Sapphires
  # # Crystals         a
  # # Emeralds         b
  #
  # grid.virtual_generate(18, false) # generate left-right grid with 18 char as max canvas width
  # # => [["Rubys", "Crystals"], ["Emeralds", "Sapphires"], ["a", "b"]]
  #
  # grid.to_s(false) # get the string format (false) in left-right direction
  # # Rubys    Crystals 
  # # Emeralds Sapphires
  # # a        b
  #
  # grid.to_s(false, false)
  # #    Rubys  Crystals
  # # Emeralds Sapphires
  # #        a         b
  #
  # Let's see another example for custom separator.
  # ```
  # grid = Grid.new("Rubys Crystals Emeralds Sapphires a b", " | ")
  # grid.virtual_generate(20, true)
  # grid.to_s(true, false)
  # #    Rubys | Sapphires
  # # Crystals |         a
  # # Emeralds |         b
  #
  # grid.to_s(true, false, "---")
  # #    Rubys---Sapphires
  # # Crystals---        a
  # # Emeralds---        b
  #
  # grid.to_s(true, false, "........") # It works even the separator exceed virtual separator size
  # #    Rubys...Sapphires
  # # Crystals...        a
  # # Emeralds...        b
  # ```
  def to_s(top_down = true, align_left = true, sep = @separator) : String
    sep = sep[0..(@separator.size-1)] if @separator.size < sep.size
    String.build do |io|
      if top_down
        return "" if @canvas_td.empty?
        @canvas_td.first.size.times do |row|
          @col_width_td.each_with_index do |w, col|
            next unless @canvas_td[col][row]?
            io << (align_left ? @canvas_td[col][row].ljust(w, ' ') : @canvas_td[col][row].rjust(w, ' '))
            io << sep if col < (@col_width_td.size - 1)
          end
          io << "\n"
        end
      else
        return "" if @canvas_lr.empty?
        @canvas_lr.each do |row|
          row.each_with_index do |str, i|
            io << (align_left ? str.ljust(@col_width_lr[i], ' ') : str.rjust(@col_width_lr[i], ' '))
            io << sep if i < (row.size - 1)
          end
          io << "\n"
        end
      end
    end
  end

  # Generate the virtual canvas based on the current @list and specified *max width*.
  # The max width default value is 24.
  # The second parameter *top_down* specified the direction of item. True if top-down and false if left-right.
  #
  # Example:
  # ```
  # grid = Grid.new("Rubys Crystals Emeralds Sapphires a b") # Create a new Grid instance
  # 
  # grid.virtual_generate(18, true) # generate top-down grid with 18 char as max canvas width    
  # # => [["Rubys", "Crystals", "Emeralds"], ["Sapphires", "a", "b"]]
  #
  # grid.virtual_generate(18, false) # generate left-right grid with 18 char as max canvas width
  # # => [["Rubys", "Crystals"], ["Emeralds", "Sapphires"], ["a", "b"]]
  # ```
  def virtual_generate(max_w = 24, top_down = true)
    @max_width = max_w
    top_down ? virtual_top_down : virtual_left_right
  end
end

