Loudspeaker
===========

A `Loudspeaker` is a BrickAudio which outputs audio to loudspeakers or headphones. 




Define the `Loudspeaker` class
------------------------------

    class Loudspeaker extends BrickAudio
      I: 'Loudspeaker'




Define the constructor
----------------------

      constructor: (opt={}) ->
        super




Define public methods
---------------------

#### `render()`
Xx. 

      render: -> [
        '.L===R.'
        '|     |'
        "I #{@id} O"
        '|     |'
        "'====='"
      ]




