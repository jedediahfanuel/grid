require "./top_down"
require "./left_right"

# `Grid` is a simple string grid formatter library for crystal programming language.
#
# Example:
#
# ```
# grid = Grid.new("Rubys Crystals Emeralds Sapphires")
# grid.virtual_generate(18) # 18 char is the max width of the canvas (not the column)
# grid.virtual_to_canvas
# grid.to_s(true) # true [default | omittable] == top-down direction | false == left-right direction
#
# # Rubys    Emeralds
# # Crystals Sapphires
# ```
struct Grid
  VERSION = "0.1.0"

  # Canvas is a variable that holds the cell of each string
  property canvas = [] of Array(String)

  # Holds the max width of the canvas.
  # Its defined by the user.
  # Default value is `24`.
  property max_width = 0

  # Holds the list of String from the user.
  #
  # Example:
  # ```
  # #         this is 1st column   this is 2nd column
  #
  # @list = [["str_1", "str_2"], ["str_9", "str_8"]]
  # ```
  property list : Array(String)

  # Initialize grid *list* with type of `Array(String)` as a input parameter.
  # Example:
  #
  # ```
  # Grid.new(["Ruby", "Crystal", "Emerald", "Sapphire"])
  # ```
  def initialize(@list : Array(String))
  end

  # Initialize grid *list* with type of `String` as a input parameter.
  #
  # Example:
  # ```
  # Grid.new("Ruby Crystal Emerald Sapphire")
  # ```
  def initialize(str : String)
    @list = str.strip.split
  end

  include LeftRight
  include TopDown

  # Count the delimiter of specified column count.
  #
  # Example:
  # ```
  # delimiter_count_of(3) # => 2
  # ```
  def delimiter_count_of(col_count : Int32) : Int32
    col_count < 1 ? 0 : col_count - 1
  end

  # Convert all elements in *canvas* to a single string using `String#build`.
  #
  # Example:
  #
  # ```
  # grid = Grid.new("Rubys Crystals Emeralds Sapphires")
  # grid.virtual_generate
  # grid.virtual_to_canvas
  # grid.to_s
  #
  # # Rubys    Emeralds
  # # Crystals Sapphires
  # ```
  def to_s(top_down = true, align_left = true, separator : Char = ' ') : String
    String.build do |io|
      if top_down
        current_row_size.times do |row|
          col_width.each_with_index do |width, col|
            if row < col_height[col]
              io << (align_left ? canvas[col][row].ljust(width, ' ') : canvas[col][row].rjust(width, ' '))
            end
            io << separator if col < (col_width.size - 1)
          end
          io << "\n"
        end
      else
        @canvas_lr.each do |row|
          row.each_with_index do |str, i|
            io << (align_left ? str.ljust(@col_width_lr[i], ' ') : str.rjust(@col_width_lr[i], ' '))
            io << separator if i < (row.size - 1)
          end
          io << "\n"
        end
      end
    end
  end

  # Calculate the row & height to the one column sized.
  #
  # Example:
  # ```
  # @list = [
  #   "str_1",
  #   "str_3",
  #   "str_2",
  #   "str_4",
  #   "str_5",
  #   "str_6",
  #   "str_7",
  # ]
  #
  # virtual_one_column
  # # @col_width = [5]
  # # @col_height = [7]
  # ```
  def virtual_one_column
    @canvas.clear
    @col_width.clear
    @col_width << @list.max_by { |elm| elm.size }.size
    @current_row_size = @list.size
    @col_height = [@current_row_size]
    return
  end

  # Generate the virtual canvas based on the current *list* and specified *max width*.
  # The max width default value is 24.
  #
  # Example:
  # ```
  # @canvas = [] of Array(String)
  # @list = ["str_1", "str_30", "str_200", "str_4000", "str_50000"]
  #
  # virtual_generate # generate our virtual canvas with default value of @max_width = 24
  #
  # # Then our virtual_canvas are
  # @col_width = [7, 9]
  # @col_height = [3, 2]
  #
  # # str_1   str_4000
  # # str_30  str_50000
  # # str_200
  #
  # virtual_generate(25) # generate our virtual canvas @max_width = 25
  #
  # Then our virtual_canvas are
  # @col_width = [7, 9]
  # @col_height = [3, 2]
  #
  # # str_1  str_200  str_50000
  # # str_30 str_4000
  # ```
  #
  # NOTE: currently only support top-down direction
  def virtual_generate(max_w = 24, top_down = true)
    flush
    @max_width = max_w

    top_down ? virtual_top_down : virtual_left_right
  end

  # Install the *list* to the *canvas* based on the virtual_canvas.
  #
  # Example:
  # ```
  # @canvas = [] of Array(String)
  # @list = ["str_1", "str_30", "str_200", "str_4000", "str_50000"]
  #
  # # Then our virtual_canvas are
  # @col_width = [7, 9]
  # @col_height = [3, 2]
  #
  # # Then we call `virtual_to_canvas`
  # virtual_to_canvas
  #
  # # Our canvas would be like this
  # @canvas = [
  #   ["str_1", "str_30", "str_200"], # this is column 1
  #   ["str_4000", "str_50000"],      # this is column 2
  # ]
  # ```
  def virtual_to_canvas(top_down = true) : Array(Array(String))
    if top_down
      virtual_col = highest_virtual_row > 0 ? highest_virtual_row : 1
      @canvas = @list.each_slice(virtual_col).map { |col| col }.to_a
    else
      virtual_row = @col_width_lr.size > 0 ? @col_width_lr.size : 1
      @canvas_lr = @list.each_slice(virtual_row).map { |row| row }.to_a
    end
  end
end
