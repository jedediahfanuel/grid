module TopDown
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
  
  # Holds the currently highest column value.
  #
  # Example:
  # ```
  # @canvas = [
  #   ["a", "b", "c"], # => column 1 :: has 3 row
  #   ["d", "e"],      # => column 2 :: has 2 row
  # ]
  #
  # # so the highest row is 3
  # # and its became the value of @current_row_size
  # ```
  property current_row_size = 0
  
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
  # # @current_row_size = 0
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
  # # @current_row_size = 0
  # # @max_width = 0
  # # @list.clear
  # ```
  def flush(all : Bool = false)
    @canvas.clear
    @col_height.clear
    @col_width.clear
    @current_row_size = 0
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
  # highest_virtual_col # => 4
  # ```
  def highest_virtual_col : Int32
    temp = @col_height.max?
    temp ? temp : 0
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
  
  # Rearrange the virtual canvas due to newly str using top down direction.
  # It returns `true` if there's a valid re-arrangement.
  # It returns `false` if there's no valid re-arrangement.
  private def virtual_rearrange_top_down(str : String, str_index : Int32) : Bool
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
          @current_row_size = candidate_cols_height
  
          col_count = candidate_cols_width.size
          @col_height = Array(Int32).new(col_count, @current_row_size)
          @col_height[-1] = last_col_height
  
          @col_width = candidate_cols_width
          return true
        end
      end
  
      buffer += current_col_height
    end
  
    return false
  end
  
  private def virtual_top_down
    @list.each_with_index do |str, i|
      if str.size >= @max_width
        virtual_one_column
        return
      end

      if @col_height.empty? || @col_height.last >= highest_virtual_col
        if get_next_width(str) < @max_width
          @col_height << 1
          @col_width << str.size
          @current_row_size = highest_virtual_col
        else
          unless virtual_rearrange_top_down(str, i)
            virtual_one_column
            return
          end
        end
      else
        if get_next_width(str, -2) < @max_width
          @col_height[-1] += 1
          @col_width[-1] = str.size if str.size > @col_width[-1]
        else
          unless virtual_rearrange_top_down(str, i)
            virtual_one_column
            return
          end
        end
      end
    end
  end  
end
