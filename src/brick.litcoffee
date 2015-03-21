Brick
=====

`Brick` can be accessed on the `CheeSynth` class, eg:  
`myBrick = new CheeSynth.Brick()` 




Define the `Brick` class
------------------------

    class Brick
      toString: -> "[object Brick #{@id}]"




Define the constructor
----------------------

      constructor: (opt) ->
        @id     = opt.id




Define public methods
---------------------


#### `getIns()` and `getIns()`
Returns the relative coordinates of this brick's input and output points. 

      #getIns : -> [ [1,0], [5,0] ]
      #getOuts: -> [ [1,4], [5,4] ]


#### `render()`
Xx. 

      render: -> [
        'L--M--R'
        '|     |'
        "C #{@id} c"
        '|     |'
        'l==m==r'
      ]




