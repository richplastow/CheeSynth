Component
=========

Component can be accessed on the CheeSynth class, eg using 
`cpt = new CheeSynth.Component()`. 




Define the `Component` class
----------------------------

    class CheeSynth.Component
      toString: -> '[object Component]'




Define the constructor
----------------------

      constructor: (opt) ->
        @id = opt.id




Define public methods
---------------------

#### `render()`
Xx. 

      render: -> [
        '.-V-V-.'
        '|     |'
        "| #{@id} |"
        '|     |'
        "'=V=V='"
      ]



