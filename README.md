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

grid = Grid.new("Rubys Crystals Emeralds Sapphires")
grid.virtual_generate(18) # 18 char is the max width of the canvas (not the column)  
grid.virtual_to_canvas
grid.to_s(true) # true [default | omittable] == top-down direction | false == left-right direction

# Rubys    Emeralds 
# Crystals Sapphires

```

## Development

Work in progress

- [x] Auto grid

- [ ] Direction

   - [x] top-down
   - [ ] left-right
   
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
