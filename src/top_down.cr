module TopDown
  # Canvas is a variable that holds the cell of each string in grid format.
  # In @canvas_td, each element in the array is representing a column.
  # 
  # Example:
  # ```
  # @canvas_td = [["Rubys", "Crystals", "Emeralds"], ["Sappgires", "a", "b"]]
  #
  # # It is Top-Down
  # # Rubys    Sappgires
  # # Crystals a        
  # # Emeralds b        
  # ```
  property canvas_td = [] of Array(String)

  # Holds curently max width for every column.
  #
  # Example:
  # ```
  # @canvas_td = [["Rubys", "Crystals", "Emeralds"], ["Sappgires", "a", "b"]]
  # @col_width_td = [8, 9]
  #
  # # => 1st column width is 6 char
  # # => 2nd column width is 7 char
  # # => 3rd column width is 9 char
  # ```
  property col_width_td = [] of Int32

  # Calculate each column width for canvas with virtually col item of *col_size*.
  #
  # Returning the width of every column in type Array(Int32)
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
  # virtual_column_width_td(3) # => [7, 9]
  #
  # # Virtual column would be like
  # # str_1   str_4000
  # # str_30  str_50000
  # # str_200
  #
  # virtual_column_width_td(2) # => [6, 8, 9]
  #
  # # Virtual column would be like
  # # str_1  str_200  str_50000
  # # str_30 str_4000
  # ```
  def virtual_column_width_td(col_size : Int32) : Array(Int32)
    ary = [] of Int32
    @canvas_td.clear

    @list.each_slice(col_size) do |col|
      @canvas_td << col
      ary << col.max_by { |elm| elm.size }.size
    end

    return ary
  end

  # Return canvas with the size of one column.
  # Its set @canvas_td and calculate the @col_width_td
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
  # virtual_one_column_td # => [["str_1", "str_30", "str_200", "str_4000", "str_50000"]]
  # ```
  def virtual_one_column_td : Array(Array(String))
    cw = @list.max_of?(&.size)
    @col_width_td = cw ? [cw] : @col_width_td.clear
    
    @canvas_td.clear
    @canvas_td << @list
  end

  private def virtual_top_down : Array(Array(String))
    return @canvas_td if @list.empty?
    
    final_cols_width = 1.upto(@list.size).each do |c|
      candidate_cols_width = virtual_column_width_td(c)
      if (candidate_cols_width.sum(0) + (delimiter_count_of(candidate_cols_width.size) * @separator.size)) <= @max_width
        break candidate_cols_width
      end
    end

    unless final_cols_width
      return virtual_one_column_td
    end

    @col_width_td = final_cols_width
    @canvas_td
  end
end
