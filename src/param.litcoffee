Param
=====

A brick which provides a single output, `O`. 




Define the `Param` class
------------------------

    class Param extends Brick
      I: 'Param'




Define the constructor
----------------------

      constructor: (opt) ->
        super
        @O = 0




Define public methods
---------------------

#### `render()`
Xx. 

      render: -> [
        ".=#{@zeroPad @O, 3}=."
        "| #{@id} O"
        "'====='"
      ]


