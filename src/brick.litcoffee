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
        @id = @I.charAt(0).toLowerCase() + zeroPad ++tally




Define public methods
---------------------

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




Define private static methods
-----------------------------

#### `zeroPad()`
Only works up to 10 characters. @todo smarter way of dealing with ids

      zeroPad = (x, l=2) -> ('0000000000' + x).substr -Math.max l, (x+'').length



