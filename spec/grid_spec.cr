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
      
      it "should reset the @row" do
        grid.row.should eq(0)
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
      
      it "should reset the @row" do
        grid.row.should eq(0)
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
