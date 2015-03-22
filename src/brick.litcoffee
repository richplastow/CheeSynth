Brick
=====

The base class for all the more specialized `Brick` subclasses. 




Define the `Brick` class
------------------------

    class Brick
      I: 'Brick'
      toString: -> "[object #{I} #{@id}]"
      tally = 0




Define the constructor
----------------------

      constructor: (opt) ->
        @id = @I.charAt(0).toLowerCase() + @zeroPad ++tally #@todo smarter way of dealing with ids




Define public methods
---------------------

#### `maintain()`
Xx. 

      maintain: (from, to) ->


#### `connect()`
Xx. 

      connect: (from, to) ->


#### `disconnect()`
Xx. 

      disconnect: (from, to) ->


#### `render()`
Xx. 

      render: -> [
        '.=====.'
        '|     |'
        "| #{@id} |"
        '|     |'
        "'====='"
      ]


#### `@zeroPad()`
Only works up to 10 characters. @todo move to utility class

      zeroPad: (x, l=2) -> ('0000000000' + x).substr -Math.max l, (x+'').length



