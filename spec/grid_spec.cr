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
    it "0 columns should equal 0 delimiter" do
      grid = create_filled_object
      grid.delimiter_count_of(0).should eq(0)
    end
      
    (1..10).each do |i|
      it "#{i} columns should equal #{i-1} delimiter" do
        grid = create_filled_object
        grid.delimiter_count_of(i).should eq(i-1)
      end
    end
  end
  
  describe ".delimiter_count" do
    it "0 columns should equal 0 delimiter" do
      grid = create_object_with_col(0)
      grid.delimiter_count.should eq(0)
    end
      
    (1..10).each do |i|
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
      (1..10).each do |i|
        it "#{i} columns should equal #{i-1} delimiter" do
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
end
