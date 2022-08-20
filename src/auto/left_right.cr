module LeftRight
  # Canvas is a variable that holds the cell of each string in grid format.
  # In @canvas_ld, each element in the array is representing a row.
  #
  # Example:
  # ```
  # @canvas_lr = [["Rubys", "Crystals"], ["Emeralds", "Sapphires"], ["a", "b"]]
  #
  # # It is Left-Right
  # # Rubys    Crystals 
  # # Emeralds Sapphires
  # # a        b  
  # ```
  property canvas_lr : Array(Array(String)) = [] of Array(String)

  # Holds curently max width for every column.
  #
  # Example:
  # ```
  # @canvas_lr = [["Rubys", "Crystals"], ["Emeralds", "Sapphires"], ["a", "b"]]
  # @col_width_lr = [8, 9]
  #
  # # => 1st column width is 6 char
  # # => 2nd column width is 7 char
  # # => 3rd column width is 9 char
  # ```
  property col_width_lr : Array(Int32) = [] of Int32

  # Return canvas with the size of one column.
  # Its set @canvas_lr and calculate the @col_width_lr
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
  # one_column_lr # => [["str_1"], ["str_30"], ["str_200"], ["str_4000"], ["str_50000"]]
  # ```
  def one_column_lr : Array(Array(String))
    cw = @list.max_of?(&.size)
    @col_width_lr = cw ? [cw] : @col_width_lr.clear

    @canvas_lr.clear
    @canvas_lr = @list.map { |row| [row] }
  end

  # Calculate each column width for canvas with virtually row item of *row_size*.
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
  # virtual_column_width_lr(3) # => [8, 9, 7]
  #
  # # Virtual column would be like
  # # str_1    str_30    str_200
  # # str_4000 str_50000
  #
  # virtual_column_width_lr(2) # => [9, 8]
  #
  # # Virtual column would be like
  # # str_1     str_30
  # # str_200   str_4000
  # # str_50000
  # ```
  def virtual_column_width_lr(row_size : Int32) : Array(Int32)
    return [] of Int32 if @list.empty?
    
    ary = @list.each_slice(row_size).reduce(Array(Int32).new(row_size, 0)) do |memo, row|
      memo.map_with_index do |n, i|
        row[i]? ? row[i].size > n ? row[i].size : n : n
      end
    end

    return ary
  end

  private def virtual_left_right : Array(Array(String))
    return @canvas_lr if @list.empty?
    col_count, temp_size = 1, 0

    @list.each_with_index do |str, i|
      temp_size += str.size
      break col_count = (i + 1) if (temp_size + (delimiter_count_of(i + 1) * @separator.size)) >= @max_width
    end

    if col_count < 2
      return one_column_lr
    end

    final_cols_width = col_count.downto(2).each do |c|
      candidate_cols_width = virtual_column_width_lr(c)
      break candidate_cols_width if (candidate_cols_width.sum(0) + (delimiter_count_of(c) * @separator.size)) <= @max_width
    end

    unless final_cols_width
      return one_column_lr
    end

    @col_width_lr = final_cols_width
    @canvas_lr = @list.each_slice(@col_width_lr.size).map { |row| row }.to_a
  end
end
