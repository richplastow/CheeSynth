CheeSynth
=========




Define the `CheeSynth` class
----------------------------

    class CheeSynth
      toString: -> '[object CheeSynth]'




Define the constructor
----------------------

      constructor: (opt={}) ->
        @el         = opt.el
        @width      = opt.width
        @height     = opt.height
        @fixtures   = []




Define public methods
---------------------

#### `add()`
Add a premade `Brick` instance to the cheeseboard, by wrapping it in a newly 
created `Fixture` instance. 

      add: (x, y, brick) ->
        @fixtures.push fixture = new Fixture
          id:    'f' + @fixtures.length #@todo better system
          x:     x
          y:     y
          brick: brick
        fixture




#### `composit()`
Usually called after fixtures have been added, moved or removed. 

      composit: ->

Rebuild `@cb` (the cheeseboard), a 2D array of empty objects. 

        @cb = ({} for i in [1..@height] for i in [1..@width])

Initialize `@cb.helper`, which will be used to connect the bricks together. 

        @cb.helper = { top:{}, right:[], bottom:[], left:{} }

Composit the fixtures, and throw an error if any overlap or are out of bounds. 
This operation also populates `@cb.helper`. 

        fixture.composit @cb for fixture in @fixtures

Step downward from each bottom-edge pin until a top-edge character is reached. 
If the top-edge character is also a pin, draw a vertical line between them. 

        for pin in @cb.helper.bottom # all `@cb.helper.bottom` elements are pins
          y = pin.y
          while @height > y
            char = @cb.helper.top[ pin.x + ',' + y ]
            if char # `undefined` for empty areas of cheeseboard
              if char.p # `false` for top-edge characters which are not pins
                #@todo tell the two bricks about their connection
                y = pin.y + 1
                while char.y > y
                  @cb[pin.x][y] = { c:'|' }
                  y++
              break
            y++

Step rightward from each right-edge pin until a left-edge character is reached. 
If the left-edge character is also a pin, draw a horizontal line between them. 

        for pin in @cb.helper.right # all `@cb.helper.right` elements are pins
          x = pin.x
          while @width > x
            char = @cb.helper.left[ x + ',' + pin.y ]
            if char # `undefined` for empty areas of cheeseboard
              if char.p # `false` for left-edge characters which are not pins
                #@todo tell the two bricks about their connection
                x = pin.x + 1
                while char.x > x
                  @cb[x][pin.y].c = if '|' == @cb[x][pin.y].c then '+' else '—' #@todo test em-dash on various devices
                  x++
              break
            x++

        return # simplify compiled JavaScript




#### `render()`
Convert the cheeseboard to a string. Optionally, it can be marked up with HTML. 

      render: ->

Before rendering the CheeSynth, composit all fixtures and connections

        @composit() #@todo only if fixtures have been added, moved or removed since the last render

Draw each ‘pixel’, row by row. 

        out = ''
        for y in [0..@height-1]
          for x in [0..@width-1]
            c = @cb[x][y].c
            out += if c then c else '·' #@todo test mid-dot on various devices
          out += '\n'

Wrap mid-dots in <EM> elements, so that CSS can knock them back @todo

Send the result to the display element. @todo if present - we might be serverside, or unit testing

        @el.innerHTML = out




