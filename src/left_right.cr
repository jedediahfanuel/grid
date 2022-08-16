module LeftRight
  # Canvas is a variable that holds the cell of each string
  property canvas_lr = [] of Array(String)

  # Holds curently max width for every column.
  #
  # Example:
  # ```
  # @col_width_lr = [6, 7, 9]
  #
  # # => 1st column width is 6 char
  # # => 2nd column width is 7 char
  # # => 3rd column width is 9 char
  # ```
  property col_width_lr = [] of Int32

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
  # virtual_column_width_lr(3) # => [8, 9, 7]
  #
  # # Virtual column would be like
  # # str_1    str_30     str_200
  # # str_4000 str_50000
  #
  # virtual_column_width_lr(2) # => [9, 8]
  #
  # # Virtual column would be like
  # # str_1     str_30
  # # str_200   str_4000
  # # str_50000
  # ```
  def virtual_column_width_lr(virtual_column : Int32) : Array(Int32)
    ary = @list.each_slice(virtual_column).reduce(Array(Int32).new(virtual_column, 0)) do |memo, row|
      memo.map_with_index do |n, i|
        row[i]? ? row[i].size > n ? row[i].size : n : n
      end
    end

    return ary
  end

  def virtual_one_column_lr
    cw = @list.max_of?(&.size)
    if cw.is_a? Nil
      @col_width_lr.clear
      return
    end

    @col_width_lr = [cw]
    return
  end

  private def virtual_left_right
    col_count, temp_size = 1, 0

    @list.each_with_index do |str, i|
      temp_size += str.size
      break col_count = (i + 1) if (temp_size + delimiter_count_of(i + 1)) >= @max_width
    end

    if col_count < 2
      virtual_one_column_lr
      return
    end

    final_cols_width = col_count.downto(2).each do |c|
      candidate_cols_width = virtual_column_width_lr(c)
      break candidate_cols_width if (candidate_cols_width.sum(0) + delimiter_count_of(c)) <= @max_width
    end

    unless final_cols_width
      virtual_one_column_lr
      return
    end

    @col_width_lr = final_cols_width
  end
end
