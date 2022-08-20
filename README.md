# grid

A simple string grid formatter library for crystal programming language.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     grid:
       github: Jeddi212/grid
   ```

2. Run `shards install`

## Usage

```crystal
require "grid"

grid = Grid.new("Rubys Crystals Emeralds Sapphires a b") # Create a new Grid instance

grid.auto(18, true) # generate top-down grid with 18 char as max canvas width
grid.to_s(true) # get the string format (true) in top-down direction
# Rubys    Sapphires
# Crystals a        
# Emeralds b        

grid.auto(18, false) # generate left-right grid with 18 char as max canvas width
grid.to_s(false) # get the string format (false) in left-right direction
# Rubys    Crystals 
# Emeralds Sapphires
# a        b

grid = Grid.new("Rubys Crystals Emeralds Sapphires a b", "|") # Create a new Grid instance with custom separator
grid.auto(18, true) # generate top-down grid with 18 char as max canvas width
grid.to_s(true, false) # get the string format (true) in top-down direction
#    Rubys|Sapphires
# Crystals|        a
# Emeralds|        b

```

For detailed api, check [grid docs](https://jeddi212.github.io/grid/).

## Development

Work in progress

- [x] Auto grid

- [x] Direction

   - [x] top-down
   - [x] left-right
   
- [ ] Custom header

- [ ] Manual grid 

      - [ ] col & row size
      - [ ] col width
      - [ ] elipsis
      - [ ] pass through

## Contributing

1. Fork it (<https://github.com/Jeddi212/grid/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jeddi212](https://github.com/Jeddi212) - creator and maintainer

<hr>

![Jeddi's Profile Views](https://api.visitorbadge.io/api/visitors?path=https%3A%2F%2Fgithub.com%2FJeddi212&countColor=%23fce775&style=flat-square)
