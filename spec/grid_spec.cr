require "./spec_helper"

describe Grid do

  describe "#initialize" do
    it "should initialize new Grid class from String" do
      from_string = Grid.new("Ruby Crystal Emerald Sapphire")
      from_string.list.should eq(["Ruby", "Crystal", "Emerald", "Sapphire"])
    end
    
    it "should initialize new Grid class from Array(String)" do
      from_ar_string = Grid.new(["Ruby", "Crystal", "Emerald", "Sapphire"])
      from_ar_string.list.should eq(["Ruby", "Crystal", "Emerald", "Sapphire"])
    end
    
    it "from String || Array(String) should equal" do
      from_string = Grid.new("Ruby Crystal Emerald Sapphire")
      from_ar_string = Grid.new(["Ruby", "Crystal", "Emerald", "Sapphire"])
      from_ar_string.list.should eq(from_string.list)
    end
  end
  
  describe ".delimiter_count_of" do
    grid = create_filled_object
    
    it "0 columns should equal 0 delimiter" do
      grid.delimiter_count_of(0).should eq(0)
    end
      
    (1..5).each do |i|
      it "#{i} columns should equal #{i-1} delimiter" do
        grid.delimiter_count_of(i).should eq(i-1)
      end
    end
  end
  
  describe ".delimiter_count" do
    it "0 columns should equal 0 delimiter" do
      grid = create_object_with_col(0)
      grid.delimiter_count.should eq(0)
    end
      
    (1..5).each do |i|
      it "#{i} columns should equal #{i-1} delimiter" do
        grid = create_object_with_col(i)
        grid.delimiter_count.should eq(i-1)
      end
    end
  end
  
  describe ".delimiter_count" do
    context "zero column" do
      it "0 columns should equal 0 delimiter" do
        grid = create_object_with_col(0)
        grid.delimiter_count(0).should eq(0)
      end
    end
    
    context "normal column" do 
      grid = create_object_with_col(11)
      (1..5).each do |i|
        it "#{i+1} columns should equal #{i} delimiter" do
          grid.delimiter_count(i).should eq(i)
        end
      end
    end
    
    context "over-range column should equal largest column exist" do
      it "[100] column == [5] == 4 delimiter" do
        grid = create_object_with_col(5)
        grid.delimiter_count(100).should eq(4)
      end
    end
  end
  
  describe ".flush" do
    context "all = false" do
      grid = create_filled_object
      grid.flush
      
      it "should clear the @canvas" do
        grid.canvas.should eq([] of Array(String))
      end
    
      it "should clear the @col_width" do
        grid.col_width.should eq([] of Int32)
      end
      
      it "should clear the @col_height" do
        grid.col_height.should eq([] of Int32)
      end
      
      it "should reset the @max_height" do
        grid.max_height.should eq(0)
      end
      
      it "should reset the @max_width)" do
        grid.max_width.should eq(0)
      end
      
      it "@list should save" do
        grid.list.any?.should eq(true)
      end
    end
    
    context "all = true" do 
      grid = create_filled_object
      grid.flush(true)
      
      it "should clear the @canvas" do
        grid.canvas.should eq([] of Array(String))
      end
    
      it "should clear the @col_width" do
        grid.col_width.should eq([] of Int32)
      end
      
      it "should clear the @col_height" do
        grid.col_height.should eq([] of Int32)
      end
      
      it "should reset the @max_height" do
        grid.max_height.should eq(0)
      end
      
      it "should reset the @max_width)" do
        grid.max_width.should eq(0)
      end
      
      it "should clear the @list" do
        grid.list.should eq([] of String)
      end
    end
  end
  
  describe ".highest_virtual_row" do  
    (1..5).each do |i|
      grid = create_object_with_row(i)
      it "highest row should be #{i}" do
        grid.highest_virtual_row.should eq(i)
      end
    end
  end
  
  describe ".virtual_one_column" do
    grid = Grid.new("Crystal Ruby Emerald Sapphire")
    grid.virtual_one_column
    
    it "should resulting one virtual column" do
      grid.col_width.size.should eq(1)
    end
    
    it "should resulting one virtual column" do
      grid.col_height.size.should eq(1)
    end
    
    it "canvas should equal to 1 column" do
      grid.virtual_to_canvas.size.should eq(1)
    end
    
    it "canvas column should equal to @list size" do
      grid.virtual_to_canvas.last.size.should eq(grid.list.size)
    end
  end
  
  describe ".virtual_column_width" do
    grid = Grid.new("str_1 str_20 str_300 str_4000 str_50000")
    
    context "normal condition" do
      it "should be one column" do
        ary, last_col_height = grid.virtual_column_width(2, grid.list.size)
        ary.size.should eq(1)
        ary.should eq([7])
        last_col_height.should eq(3)
      end
      
      it "should be two column" do
        ary, last_col_height = grid.virtual_column_width(2, 2)
        ary.size.should eq(2)
        ary.should eq([6, 7])
        last_col_height.should eq(3 % 2)
      end
      
      it "should be the largest column possible" do
        ary, last_col_height = grid.virtual_column_width(grid.list.size, 1)
        ary.size.should eq(grid.list.size)
        ary.should eq([5, 6, 7, 8, 9])
        last_col_height.should eq(1)
      end
    end
    
    context "over-range" do
      it "virtual_index should act as all data" do
        ary, last_col_height = grid.virtual_column_width(4, grid.list.size)
        ary.size.should eq(1)
        ary.should eq([9])
        last_col_height.should eq(5)
        
        ary_over, last_col_height_over = grid.virtual_column_width(100, grid.list.size)
        ary_over.size.should eq(1)
        ary_over.should eq([9])
        last_col_height_over.should eq(5)
        
        ary.size.should eq(ary_over.size)
        last_col_height.should eq(last_col_height_over)
      end
      
      it "virtual_row should act as one column" do
        ary, last_col_height = grid.virtual_column_width(4, grid.list.size)
        ary.size.should eq(1)
        ary.should eq([9])
        last_col_height.should eq(5)
        
        ary_over, last_col_height_over = grid.virtual_column_width(4, 100)
        ary_over.size.should eq(1)
        ary_over.should eq([9])
        last_col_height_over.should eq(5)
        
        ary.size.should eq(ary_over.size)
        last_col_height.should eq(last_col_height_over)
      end
    end
  end
  
  describe ".virtual_generate" do
    context "@list has item(s)" do
      it "@canvas should be still empty" do
        grid = create_virtual_generate("Rubys Crystals Emeralds Sapphires")
        grid.virtual_generate(18)
        grid.canvas.empty?().should eq(true)
      end
      
      it "@col_height should have any" do
        grid = create_virtual_generate("Rubys Crystals Emeralds Sapphires")
        grid.virtual_generate(18)
        grid.col_height.any?().should eq(true)
      end
      
      it "@col_width should have any" do
        grid = create_virtual_generate("Rubys Crystals Emeralds Sapphires")
        grid.virtual_generate(18)
        grid.col_width.any?().should eq(true)
      end
      
      context "correctness check" do
        grid = create_virtual_generate("Rubys Crystals Emeralds Sapphires")
        it "1st condition" do
          grid.virtual_generate(18)
          grid.col_height.should eq([2, 2])
          grid.col_width.should eq([8, 9])
        end
        
        it "2nd condition" do
          grid.virtual_generate(17)
          grid.col_height.should eq([4])
          grid.col_width.should eq([9])
        end
        
        it "3rd condition" do
          grid.virtual_generate(35)
          grid.col_height.should eq([1, 1, 1, 1])
          grid.col_width.should eq([5, 8, 8, 9])
        end
      end
      
      context "2nd correctness check" do
        grid = create_virtual_generate("a b c d e f g h j k l m n")
        
        it "1st condition" do
          grid.virtual_generate(100)
          grid.col_height.should eq([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
          grid.col_width.should eq([1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1])
        end
        
        it "2nd condition" do
          grid.virtual_generate(0)
          grid.col_height.should eq([13])
          grid.col_width.should eq([1])
        end
        
        it "3rd condition" do
          grid.virtual_generate(3)
          grid.col_height.should eq([7, 6])
          grid.col_width.should eq([1, 1])
        end
      end
    end
    
    context "@list has no item" do
      grid = Grid.new("")
      grid.virtual_generate
      
      it "@canvas should be still empty" do
        grid.canvas.empty?().should eq(true)
      end
      
      it "@col_height should have any" do
        grid.col_height.empty?().should eq(true)
      end
      
      it "@col_width should have any" do
        grid.col_width.empty?().should eq(true)
      end
    end
  end
  
end
