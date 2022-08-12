# `Grid` is a string grid formatter library
struct Grid
  VERSION = "0.1.0"

  # Canvas is a variable that holds the cell of each string
  property canvas = [] of Array(String)

  # Holds curently max width for every column.
  #
  # Example:
  # ```
  # @col_width = [6, 7, 9]
  #
  # # => 1st column width is 6 char
  # # => 2nd column width is 7 char
  # # => 3rd column width is 9 char
  # ```
  property col_width = [] of Int32

  # Holds curently max height for every column.
  #
  # Example:
  # ```
  # @col_height = [4, 4, 3]
  #
  # # => 1st column height is 4 string
  # # => 2nd column height is 4 string
  # # => 3rd column height is 3 string
  # ```
  property col_height = [] of Int32

  # Holds the max width of the canvas.
  # Its defined by the user.
  # Default value is `24`.
  property max_width = 0

  # Holds the currently highest column value.
  #
  # Example:
  # ```
  # @canvas = [
  #   ["a", "b", "c"], # => column 1 :: has row 3
  #   ["d", "e"],      # => column 2 :: has row 2
  # ]
  #
  # # so the highest row is 3
  # # and its became the value of @max_height
  # ```
  property max_height = 0

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

  # Count the delimiter of specified column count.
  #
  # Example:
  # ```
  # delimiter_count_of(3) # => 2
  # ```
  def delimiter_count_of(col_count : Int32) : Int32
    col_count < 1 ? 0 : col_count - 1
  end

  # Count the delimiter of the whole column.
  # Example:
  # ```
  # # Say we have a list like this
  # [["a"], ["b"], ["c"]]
  # delimiter_count # => 2
  # ```
  def delimiter_count : Int32
    col_size = @col_width.size
    col_size < 1 ? col_size : col_size - 1
  end

  # Count the delimiter of ranged column from range first to the specified index.
  # Example:
  # ```
  # # Say we have a list like this
  # [["a"], ["b"], ["c"]] # [0..1] ~> [["a"], ["b"]]
  # delimiter_count(1)    # => 1
  # ```
  def delimiter_count(i : Int32) : Int32
    col_size = @col_width[0..i].size
    col_size < 1 ? 0 : col_size - 1
  end

  # Flush all of the variable.
  #
  # Example:
  # ```
  # flush
  # # @canvas.clear
  # # @col_height.clear
  # # @col_width.clear
  # # @max_height = 0
  # # @max_width = 0
  # ```
  #
  # Use `flush(true)` will reset the *list* variable too.
  #
  # Example:
  # ```
  # flush(true)
  # # @canvas.clear
  # # @col_height.clear
  # # @col_width.clear
  # # @max_height = 0
  # # @max_width = 0
  # # @list.clear
  # ```
  def flush(all : Bool = false)
    @canvas.clear
    @col_height.clear
    @col_width.clear
    @max_height = 0
    @max_width = 0

    @list.clear if all
    return
  end

  # Get nextly width if we insert the newly str to the last column
  # `@col_width + delimiter_count + str.size`.
  private def get_next_width(str : String) : Int32
    @col_width.sum(0) + delimiter_count + str.size
  end

  # Get nextly width from first column to the specified column if we insert the newly str.
  # Ignored column width that out of bound.
  # Index start from last column.
  # Example:
  # @col_width = [4, 4, 3, 3]
  # newly_str = "four"

  # get_next_width(newly_str, 2)
  # # => col_width[0..-2] + delimiter_count(2) + 4
  # # => (4 + 4 = 3) + 2 + 4
  # # => 17
  private def get_next_width(str : String, i : Int32) : Int32
    @col_width[0..i].sum(0) + delimiter_count(i) + str.size
  end

  # Get the highest of col_height.
  #
  # Example:
  # ```
  # @col_height = [4, 4, 3]
  # highest_virtual_row # => 4
  # ```
  def highest_virtual_row : Int32
    temp = @col_height.max?
    temp ? temp : 0
  end

  def to_s(align_left = true, separator = " ") : String
    String.build do |io|
      if align_left
        max_height.times do |row|
          col_width.each_with_index do |width, col|
            io << canvas[col][row].ljust(width, ' ') if row < col_height[col]
            io << separator if col < (col_width.size - 1)
          end
          io << "\n"
        end
      end
    end
  end

  # Calculate column width for canvas virtually to the range of data.
  #
  # Returning the width of every column in an array, plus the column height of the last column
  #
  # Example:
  # ```
  # @list = [
  #   "str_1",
  #   "str_30",
  #   "str_200",
  #   "str_4000",
  #   "str_50000",
  # ]
  # virtual_column_width(4, 3) # => { [7, 9], 2 }
  #
  # # Virtual column would be like
  # # str_1   str_4000
  # # str_30  str_50000
  # # str_200
  #
  # virtual_column_width(3, 2) # => { [6, 7], 1 }
  #
  # # Virtual column would be like
  # # str_1  str_200
  # # str_30
  # ```
  #
  # If virtual_index argument is larger than *list* size, than it will use the *list* size instead.
  # NOTE: virtual index is act like an index `its starts from 0`
  # Example:
  # ```
  # @list = [
  #   "str_1",
  #   "str_30",
  #   "str_200",
  #   "str_4000",
  #   "str_50000",
  # ]
  #
  # virtual_column_width(100, 3) # => { [7, 9], 2 }
  #
  # # Virtual column would be like
  # # str_1   str_4000
  # # str_30  str_50000
  # # str_200
  # ```
  #
  # Height parameter act same like virtual_index.
  # Example:
  # ```
  # @list = [
  #   "str_1",
  #   "str_30",
  #   "str_200",
  #   "str_4000",
  #   "str_50000",
  # ]
  #
  # virtual_column_width(4, 100) # => { [9], 5 }
  #
  # # Virtual column would be like
  # # str_1
  # # str_30
  # # str_200
  # # str_4000
  # # str_50000
  # ```
  def virtual_column_width(virtual_index : Int32, virtual_row : Int32) : Tuple(Array(Int32), Int32)
    virtual_index = virtual_index > @list.size ? -1 : virtual_index
    last_col_height = 0

    ary = @list[0..virtual_index].each_slice(virtual_row).map do |new_col|
      last_col_height = new_col.size
      new_col.max_by { |elm| elm.size }.size
    end.to_a

    return ary, last_col_height
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
    @max_height = @list.size
    @col_height = [@max_height]
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
  def virtual_generate(max_w = 24)
    flush
    @max_width = max_w

    @list.each_with_index do |str, i|
      if str.size >= @max_width
        virtual_one_column
        return
      end

      if @col_height.empty? || @col_height.last >= highest_virtual_row
        if get_next_width(str) < @max_width
          @col_height << 1
          @col_width << str.size
          @max_height = highest_virtual_row
        else
          unless virtual_rearrange(str, i)
            virtual_one_column
            return
          end
        end
      else
        if get_next_width(str, -2) < @max_width
          @col_height[-1] += 1
          @col_width[-1] = str.size if str.size > @col_width[-1]
        else
          unless virtual_rearrange(str, i)
            virtual_one_column
            return
          end
        end
      end
    end
  end

  # Rearrange the virtual canvas due to newly str.
  # It returns `true` if there's a valid re-arrangement.
  # It returns `false` if there's no valid re-arrangement.
  private def virtual_rearrange(str : String, str_index : Int32) : Bool
    @col_height[-1] += 1
    @col_width[-1], buffer = str.size, 0

    @col_height[1..].reverse.each_with_index(1) do |current_col_height, idx|
      (1..(current_col_height + buffer)).each do |i|
        candidate_cols_height = @col_height.first + i
        candidate_cols_width, last_col_height = virtual_column_width(
          str_index,
          candidate_cols_height
        )
        candidate_size = candidate_cols_width.sum + delimiter_count_of(candidate_cols_width.size)

        if candidate_size <= @max_width
          @max_height = candidate_cols_height

          col_count = candidate_cols_width.size
          @col_height = Array(Int32).new(col_count, @max_height)
          @col_height[-1] = last_col_height

          @col_width = candidate_cols_width
          return true
        end
      end

      buffer += current_col_height
    end

    return false
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
  def virtual_to_canvas : Array(Array(String))
    virtual_row = highest_virtual_row > 0 ? highest_virtual_row : 1
    @canvas = @list.each_slice(virtual_row).map { |col| col }.to_a
  end
end

