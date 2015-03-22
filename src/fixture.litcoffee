Fixture
=======




Define the `Fixture` class
--------------------------

    class Fixture
      toString: -> "[object Fixture #{@id}]"




Define the constructor
----------------------

      constructor: (opt) ->
        @id     = opt.id
        @x      = opt.x
        @y      = opt.y
        @brick  = opt.brick




Define public methods
---------------------

#### `insert()`
Adds the fixture’s brick into the `cb` array, which represents a cheeseboard. 

      insert: (cb) ->

Make sure the fixture’s (x,y) coords are within cheeseboard bounds. 

        if 0 > @x || 0 > @y then throw new Error "#{@} has -ve position"
        if ! cb[@x]         then throw new Error "#{@} is beyond x edge"
        if ! cb[@x][@y]     then throw new Error "#{@} is beyond y edge"

Step through each line of the fixture’s brick. 

        lines = @brick.render()
        for line,y in lines
          absY = @y+y
          if ! cb[@x][absY] then throw new Error "#{@} is too tall"

Step through each character of the brick’s current line. 

          for char,x in line.split '' #@todo `@brick.render()` return a 2D array
            absX = @x+x
            col = cb[absX]
            if ! col then throw new Error "#{@} is too wide"
            if col[absY].f then throw new Error "#{@} overlaps #{col[absY].f}"

Record the character in the proper (x,y) position of the cheeseboard, along 
with a reference to this fixture. 

            meta = col[absY] = { f:@, c:char, x:absX, y:absY }

Searching for connected bricks is a potential bottleneck, akin to collision 
detection. To improve performance, we will cache information about each brick’s 
perimeter. Firstly, determine whether this character is on an edge or corner. 

            isTop  = 0 == y
            isLeft = 0 == x
            isBottom = lines.length-1 == y
            isRight  = line.length-1  == x

Don’t add the inner characters of bricks to `cb.helper`, just the edges. 

            if isTop || isRight || isBottom || isLeft

Avoid re-testing `char` in `CheeSynth.composite()`, by caching the result. 

              meta.p = /[a-zA-Z]/.test char # `p` means ‘is a pin’

Pin or not, top and left edge characters always halt incoming connections. 

              if isTop  then cb.helper.top[  absX + ',' + absY ] = meta
              if isLeft then cb.helper.left[ absX + ',' + absY ] = meta

Pins on the right and bottom edges can send outgoing connections. Note that we 
don’t cache information about non-pin characters on the right and bottom edges, 
because they can’t effect the way that bricks are connected. 

              if meta.p
                if isRight  then cb.helper.right.push  meta
                if isBottom then cb.helper.bottom.push meta

        return # simplify compiled JavaScript


