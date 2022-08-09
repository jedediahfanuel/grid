# `Grid` is a string grid formatter library
module Grid
  VERSION = "0.1.0"
  # Generate grid output with *list* type of `String` as a input parameter
  #
  # Example:
  # ```
  # Grid.get("")
  # ```
  def self.get(list : String)
    height, width = {38, 169}
    list = list.strip
    print list
  end
  
  # Generate grid output with *list* type of `Array(String)` as a input parameter
  #
  # Example:
  # ```
  # Grid.get("")
  # ```
  def self.get(list : Array(String))
    get(list.join(" "))
  end
end

Grid.get("ijiji iji jiji jij ")
Grid.get(["asdasd", "asdasda", "asdasdsads", "asdsadasd"])
