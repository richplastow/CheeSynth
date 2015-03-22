CheeSynth
=========




Define the `CheeSynth` class
----------------------------

    class CheeSynth
      toString: -> '[object CheeSynth]'




Define the constructor
----------------------

      constructor: (opt={}) ->
        @el          = opt.el
        @width       = opt.width
        @height      = opt.height
        @fixtures    = []
        @connections = {}

Xx. @todo better place for this

        CheeSynth.ctx = new AudioContext




Define public methods
---------------------

#### `add()`
Instantiate a `Brick` and a `Fixture`, wrap the `Brick` in the `Fixture`, and 
attach the `Fixture` to the cheeseboard. 

      add: (x, y, brickClass) ->
        brick = new brickClasses[brickClass]
        @fixtures.push @[brick.id] = new Fixture
          id:    'f' + @fixtures.length #@todo better system
          x:     x
          y:     y
          brick: brick
        @[brick.id]




#### `composite()`
Usually called after fixtures have been added, moved or removed. 

      composite: ->

Rebuild `@cb` (the cheeseboard), a 2D array of empty objects. 

        @cb = ({} for y in [1..@height] for x in [1..@width])

Initialize `@cb.helper`, which will be used to connect the bricks together. 

        @cb.helper = { top:{}, right:[], bottom:[], left:{} }

Composite the fixtures, and throw an error if any overlap or are out of bounds. 
This operation also populates `@cb.helper`. 

        fixture.insert @cb for fixture in @fixtures

Initialize `newConnections`, which will hold each connection found during the 
next two `for` loops. Afterwards, this will be compared to `@connections`, so 
that Bricks can be notified that they have been connected of disconnected. 

        newConnections = {}

Step downward from each bottom-edge pin until a top-edge character is reached. 
If the top-edge character is also a pin, draw a vertical line between them and 
update `newConnections`. 

        for sender in @cb.helper.bottom # all `@cb.helper.bottom` elements are pins
          y = sender.y
          while @height > y
            y++
            receiver = @cb.helper.top[ sender.x + ',' + y ]
            if receiver # `undefined` for empty areas of cheeseboard
              if receiver.p # `false` for top-edge characters which are not pins
                newConnections[sender.f.id + sender.c + '-' + receiver.f.id + receiver.c] = [sender, receiver]
                y = sender.y + 1
                while receiver.y > y
                  @cb[sender.x][y].c = '|'
                  y++
              break

Step rightward from each right-edge pin until a left-edge character is reached. 
If the left-edge character is also a pin, draw a horizontal line between and 
update `newConnections`. 

        for sender in @cb.helper.right # all `@cb.helper.right` elements are pins
          x = sender.x
          while @width > x
            x++
            receiver = @cb.helper.left[ x + ',' + sender.y ]
            if receiver # `undefined` for empty areas of cheeseboard
              if receiver.p # `false` for left-edge characters which are not pins
                newConnections[sender.f.id + sender.c + '-' + receiver.f.id + receiver.c] = [sender, receiver]
                x = sender.x + 1
                while receiver.x > x
                  @cb[x][sender.y].c = if '|' == @cb[x][sender.y].c then '+' else '—' #@todo test em-dash on various devices
                  x++
              break

Step through the old list of connections, maintain connections which have not 
changed, and notify Bricks about any new disconnections. 

        for key,[sender, receiver] of @connections
          if newConnections[key]
            sender.f.brick.maintain   sender, receiver
            receiver.f.brick.maintain sender, receiver
          else
            sender.f.brick.disconnect   sender, receiver
            receiver.f.brick.disconnect sender, receiver

Step through the newly updated list of connections, and notify Bricks about any 
newly made connections. 

        for key,[sender, receiver] of newConnections
          if ! @connections[key]
            sender.f.brick.connect   sender, receiver
            receiver.f.brick.connect sender, receiver

The newly found connections now represent the current set of connections, so 
replace the old set ready for the next time `composite()` is called. 

        @connections = newConnections




#### `render()`
Convert the cheeseboard to a string. Optionally, it can be marked up with HTML. 

      render: ->

Before rendering the cheeseboard, composite all fixtures and connections. 

        @composite() #@todo only if fixtures have been added, moved or removed since the last render

Draw each character, row by row, column by column. 

        out = ''
        for y in [0..@height-1]
          for x in [0..@width-1]
            c = @cb[x][y].c
            out += if c then c else '·' #@todo test mid-dot on various devices
          out += '\n'

Wrap mid-dots in `<EM>` elements, so that CSS can knock them back. @todo

Send the result to the display element. @todo if present - we might be serverside, or unit testing

        @el.innerHTML = out




