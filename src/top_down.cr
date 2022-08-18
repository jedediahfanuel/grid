module TopDown
  # Canvas is a variable that holds the cell of each string
  property canvas_td = [] of Array(String)

  # Holds curently max width for every column.
  #
  # Example:
  # ```
  # @col_width_td = [6, 7, 9]
  #
  # # => 1st column width is 6 char
  # # => 2nd column width is 7 char
  # # => 3rd column width is 9 char
  # ```
  property col_width_td = [] of Int32

  # Calculate column width for canvas virtually to the range of data.
  #
  # Returning the width of every column in Array(Int32)
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
  # virtual_column_width_td(3) # => [8, 9, 7]
  #
  # # Virtual column would be like
  # # str_1    str_30     str_200
  # # str_4000 str_50000
  #
  # virtual_column_width_td(2) # => [9, 8]
  #
  # # Virtual column would be like
  # # str_1     str_30
  # # str_200   str_4000
  # # str_50000
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

  def virtual_one_column_td
    @col_width_td = [@list.max_by { |elm| elm.size }.size]
    @canvas_td.clear
    @canvas_td << @list
  end

  private def virtual_top_down
    final_cols_width = 1.upto(@list.size).each do |c|
      candidate_cols_width = virtual_column_width_td(c)
      if (candidate_cols_width.sum(0) + delimiter_count_of(candidate_cols_width.size)) <= @max_width
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
