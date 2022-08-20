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
    
    it "should initialize new Grid class from String with custom separator" do
      from_string = Grid.new("Ruby Crystal Emerald Sapphire", " | ")
      from_string.list.should eq(["Ruby", "Crystal", "Emerald", "Sapphire"])
      from_string.separator.should eq(" | ")
    end
    
    it "should initialize new Grid class from Array(String) with custom separator" do
      from_ar_string = Grid.new(["Ruby", "Crystal", "Emerald", "Sapphire"], " | ")
      from_ar_string.list.should eq(["Ruby", "Crystal", "Emerald", "Sapphire"])
      from_ar_string.separator.should eq(" | ")
    end
  end

  describe ".delimiter_count_of" do
    grid = create_empty_grid

    it "0 columns should equal 0 delimiter" do
      grid.delimiter_count_of(0).should eq(0)
    end

    (1..3).each do |i|
      it "#{i} columns should equal #{i - 1} delimiter" do
        grid.delimiter_count_of(i).should eq(i - 1)
      end
    end
  end
  
  describe ".auto" do
    context "top-down" do
      context "@list has item(s)" do
        grid = create_auto_top_down("Rubys Crystals Emeralds Sapphires a b")
        
        it "canvas_td should not empty" do
          grid.canvas_td.should eq([["Rubys", "Crystals", "Emeralds"], ["Sapphires", "a", "b"]])
        end
        
        it "canvas_lr should empty" do
          grid.canvas_lr.empty?.should be_true
        end
      end
      
      context "with custom separator" do
        grid = create_auto_top_down_with_custom_sep("Rubys Crystals Emeralds Sapphires a b", " | ")
        
        it "canvas_td should be 4 : 2" do
          grid.auto(18, true)
          grid.canvas_td.should eq([["Rubys", "Crystals", "Emeralds", "Sapphires"], ["a", "b"]])
        end
        
        it "canvas_td should be 3 : 3" do
          grid.auto(20, true)
          grid.canvas_td.should eq([["Rubys", "Crystals", "Emeralds"], ["Sapphires", "a", "b"]])
        end
        
        it "canvas_lr should empty" do
          grid.canvas_lr.empty?.should be_true
        end
      end
      
      it "@list has no item(s)" do
        grid = create_auto_top_down("")
        grid.canvas_td.should eq([] of Array(String))
      end
    end
    
    context "left-right" do
      context "@list has item(s)" do
        grid = create_auto_left_right("Rubys Crystals Emeralds Sapphires a b")
        
        it "canvas_lr should not empty" do
          grid.canvas_lr.should eq([["Rubys", "Crystals"], ["Emeralds", "Sapphires"], ["a", "b"]])
        end
        
        it "canvas_td should empty" do
          grid.canvas_td.empty?.should be_true
        end
      end
      
      context "with custom separator" do
        grid = create_auto_left_right_with_custom_sep("Rubys Crystals Emeralds Sapphires a b", " | ")
        
        it "canvas_lr should be one column" do
          grid.auto(18, false)
          grid.canvas_lr.should eq([["Rubys"], ["Crystals"], ["Emeralds"], ["Sapphires"], ["a"], ["b"]])
        end
        
        it "canvas_lr should be 2 : 2 : 2" do
          grid.auto(20, false)
          grid.canvas_lr.should eq([["Rubys", "Crystals"], ["Emeralds", "Sapphires"], ["a", "b"]])
        end
        
        it "canvas_td should empty" do
          grid.canvas_td.empty?.should be_true
        end
      end
      
      it "@list has no item(s)" do
        grid = create_auto_left_right("")
        grid.canvas_lr.should eq([] of Array(String))
      end
    end
  end

  describe ".to_s" do
    context "top-down" do
      grid = create_auto_top_down("Rubys Crystals Emeralds Sapphires")
      
      it "should return type of String" do
        str = grid.to_s(true)
        typeof(str).should eq(String)
      end

      it "should ok with align_left" do
        str = grid.to_s(true, true)
        str.should eq("Rubys    Emeralds \nCrystals Sapphires\n")
      end

      it "should ok with align_left with custom delimiter '-'" do
        str = grid.to_s(true, true, "-")
        str.should eq("Rubys   -Emeralds \nCrystals-Sapphires\n")
      end

      it "should ok with align_right" do
        str = grid.to_s(true, false)
        str.should eq("   Rubys  Emeralds\nCrystals Sapphires\n")
      end

      it "should ok with align_right with custom delimiter '-'" do
        str = grid.to_s(true, false, "-")
        str.should eq("   Rubys- Emeralds\nCrystals-Sapphires\n")
      end

      it "should return empty string if the canvas is empty" do
        grid = Grid.new
        grid.auto(top_down: true)
        str = grid.to_s(true)
        str.should eq("")
      end
    end
    
    context "left-right" do
      grid = create_auto_left_right("Rubys Crystals Emeralds Sapphires")
      
      it "should return type of String" do
        str = grid.to_s(false)
        typeof(str).should eq(String)
      end

      it "should ok with align_left" do
        str = grid.to_s(false, true)
        str.should eq("Rubys    Crystals \nEmeralds Sapphires\n")
      end

      it "should ok with align_left with custom delimiter '-'" do
        str = grid.to_s(false, true, "-")
        str.should eq("Rubys   -Crystals \nEmeralds-Sapphires\n")
      end

      it "should ok with align_right" do
        str = grid.to_s(false, false)
        str.should eq("   Rubys  Crystals\nEmeralds Sapphires\n")
      end

      it "should ok with align_right with custom delimiter '-'" do
        str = grid.to_s(false, false, "-")
        str.should eq("   Rubys- Crystals\nEmeralds-Sapphires\n")
      end

      it "should return empty string if the canvas is empty" do
        grid = Grid.new
        grid.auto(top_down: false)
        str = grid.to_s(false)
        str.should eq("")
      end
    end
  end

  describe ".one_column" do
    ary = ["str_1", "str_30", "str_200", "str_4000", "str_50000"]
    grid = Grid.new(ary)
    grid_empty = Grid.new
    
    context "top-down" do
      grid.one_column_td
  
      it "non empty @list, @col_width_td should have size of 1" do
        grid.col_width_td.size.should eq(1)
      end
      
      it "non empty @list, @canvas_td should one column" do
        grid.canvas_td.size.should eq(1)
        grid.canvas_td.should eq([["str_1", "str_30", "str_200", "str_4000", "str_50000"]])
      end
      
      it "non empty @list, @col_width_td.first should have size of largest str" do
        grid.col_width_td.first.should eq(ary.max_of?(&.size))
      end
      
      it "empty @list, @col_width_td should have size of 0" do
        grid_empty.col_width_td.size.should eq(0)
      end
    end
    
    context "left-right" do
      grid.one_column_lr
  
      it "non empty @list, @col_width_lr should have size of 1" do
        grid.col_width_lr.size.should eq(1)
      end
      
      it "non empty @list, @canvas_lr should one column" do
        grid.canvas_lr.size.should eq(ary.size)
        grid.canvas_lr.each { |s| s.size.should eq(1) }
        grid.canvas_lr.should eq([["str_1"], ["str_30"], ["str_200"], ["str_4000"], ["str_50000"]])
      end
      
      it "non empty @list, @col_width_lr.first should have size of largest str" do
        grid.col_width_lr.first.should eq(ary.max_of?(&.size))
      end
  
      it "empty @list, @col_width_lr should have size of 0" do
        grid_empty.col_width_lr.size.should eq(0)
      end
    end
  end

  describe ".virtual_column_width_lr" do
    ary = ["str_1", "str_30", "str_200", "str_4000", "str_50000"]
    grid = Grid.new(ary)
    grid_empty = Grid.new

    context "top-down" do
      it "should pass 1st test" do
        grid.virtual_column_width_td(1).should eq([5, 6, 7, 8, 9])
      end
      
      it "should pass 2nd test" do
        grid.virtual_column_width_td(2).should eq([6, 8, 9])
      end
      
      it "should pass 3rd test" do
        grid.virtual_column_width_td(3).should eq([7, 9])
      end
      
      it "should pass 4th test" do
        grid.virtual_column_width_td(4).should eq([8, 9])
      end
      
      it "should pass 5th test" do
        grid.virtual_column_width_td(5).should eq([9])
      end
      
      it "should pass empty list" do
        grid_empty.virtual_column_width_td(1).should eq([] of Int32)
      end
    end

    context "left-right" do
      it "should pass 1st test" do
        grid.virtual_column_width_lr(1).should eq([9])
      end
      
      it "should pass 2nd test" do
        grid.virtual_column_width_lr(2).should eq([9, 8])
      end
      
      it "should pass 3rd test" do
        grid.virtual_column_width_lr(3).should eq([8, 9, 7])
      end
      
      it "should pass 4th test" do
        grid.virtual_column_width_lr(4).should eq([9, 6, 7, 8])
      end
      
      it "should pass 5th test" do
        grid.virtual_column_width_lr(5).should eq([5, 6, 7, 8, 9])
      end
      
      it "should pass empty list" do
        grid_empty.virtual_column_width_lr(1).should eq([] of Int32)
      end
    end
  end
end
