# `Grid` is a string grid formatter library
class Grid
  VERSION = "0.1.0"
  
  # Canvas is a variable that holds the cell of each string
  property canvas    = [] of Array(String)
  property col_width = [] of Int32
  property col_ptr   = 0
  property max_width = 0
  property row       = 0
  property list : Array(String)
  
  # Initialize grid with *list* type of `Array(String)` as a input parameter
  #
  # Example:
  # ```
  # Grid.new(["Ruby", "Crystal", "Emerald", "Sapphire"])
  # ```
  def initialize(@list : Array(String))
  end
  
  # Initialize grid with *list* type of `String` as a input parameter
  #
  # Example:
  # ```
  # Grid.new("Ruby Crystal Emerald Sapphire")
  # ```
  def initialize(str : String)
    @list = str.strip.split
  end
  
  # Generate grid output with *list* type of `Array(String)` as a input parameter
  #
  # Example:
  # ```
  # Grid.get("").generate
  # ```
  def generate(max_w = 24)
    @max_width = max_w
    # return ArgumentError.new("Max width is invalid") if @max_width < 1
    
    # cek str size tambah cur size, kalau kelewatan, coba cek jika dihitung dari 
    # col sebelumnya
    # kalau masih belum bisa, cek lagi ke col sebelumnya,
    # kalau sudah col [0], tambahin aja langsung
    
    # penambahannya, tambahin dulu semua elemen row pada kolom ini, baru str yg sekarang
    # kalau misal ga jadi satu kolom (2, 3, dst)
    # hitung panjang array sekarang
    # terus bagi rata ke jumlah kolom
    
    # terus harus reset col_width masing-masing col
    # terus hitung lagi masing-masing kolom berapa width nya
    # jumlah row nya juga update
    @list.each_with_index do |str, i|
      return @canvas = [list] if str.size >= @max_width
      
      if @canvas.empty? || @canvas[-1].size >= row # empty canvas || the latest col is full -> make new col
        if get_next_width(str) < @max_width        # if the new col of str.size is fit the max width size
          @canvas << [str] of String               # just append it as the first element
          @col_width << str.size
        else                                       # if not fit, me must re arrange the canvas, -1 col
          @col_ptr = check_col(str)
          if @col_ptr >= 0
            rearrange(i, @col_ptr + 1)
          else
            flush
            return @canvas = [list]
          end
        end
      else                                         # the last col has some space for the new str
        if get_next_width(str) < @max_width        # if the new col of str.size is fit the max width size
          @canvas[-1] << str                       # just append it to the last element
          @col_width[-1] = str.size if str.size > @col_width[-1] # update the col_width if new str size is bigger
          @row += 1
        else                                       # if not fit, me must re arrange the canvas, -1 col
          @col_ptr = check_col(str)
          if @col_ptr >= 0
            rearrange(i, @col_ptr + 1)
          else
            flush
            return @canvas = [list]
          end
        end
      end
    end
    
    @canvas
  end
  
  # def to_s
  #   @canvas.map do |row|
      
  #   end
  # end
  
  # Flush (reset) the data from these attribute
  # ```
  # @col_ptr
  # @canvas
  # ```
  # 
  # And set these attribute to the newly `one_column` method
  # ```
  # @col_width # => longest str in the list
  # @row       # => current row height ( list.size )
  # ```
  private def flush
    @col_ptr = 0
    @col_width.clear
    @col_width << @list.max_by { |elm| elm.size }.size
    @canvas.clear
    @row = @list.size
  end
  
  private def rearrange(str_index : Int32, col_count : Int32)
    @row = (str_index+1 / col_count).ceil.to_i
    @canvas.clear
    @col_width.clear
      
    @list[0..str_index].each_slice(@row) do |new_col|
      @canvas << new_col
      @col_width << new_col.max_by { |elm| elm.size }.size
    end
  end
  
  # TODO : Check dengan geser satu-satu
  private def check_col(str : String) : Int32
    is_fit = -1
    
    (1..@col_width.size).each do |i|
      if get_next_width(str, i) < @max_width
        break is_fit = @col_width.size - i
      end
    end
    
    is_fit
  end
  
  private def delimiter_count : Int32
    col_size = @col_width.size
    col_size <= 1 ? col_size : col_size - 1
  end
  
  private def delimiter_count(i : Int32) : Int32
    col_size = @col_width[0..-i].size
    col_size < 1 ? col_size : col_size - 1
  end
  
  private def get_next_width(str : String) : Int32
    @col_width.sum(0) + delimiter_count + str.size
  end
  
  private def get_next_width(str : String, i : Int32) : Int32
    @col_width[0..-i].sum(0) + delimiter_count(i) + str.size
  end
  
  def one_column : String
    @list.join("\n")
  end
end

a = Grid.new("Rubys Crystals Emeralds Sapphires")
b = Grid.new(["Java", "Lua", "C#", "Perl", "Kotlin", "ABAB", "Pascal", "Rust", "Zig", "C++", "C", "APL"])

a.generate(20).each { |x| puts x }
p ""
p ""
p ""
p ""
b.generate(40).each { |x| puts x }

