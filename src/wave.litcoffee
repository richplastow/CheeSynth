Wave
====

A `Wave` is a BrickAudio which produces a waveform. 




Define the `Wave` class
------------------------

    class Wave extends BrickAudio
      I: 'Wave'




Define the constructor
----------------------

      constructor: (opt={}) ->
        super
        @oscillator = CheeSynth.ctx.createOscillator()
        @oscillator.type            = opt.type || 'square'
        @oscillator.frequency.value = opt.freq || 70
        @oscillator.start()




Define public methods
---------------------

#### `maintain()`
Xx. 

      maintain: (from, to) ->
        claud.log @id + '.' + from.c, 'still connected to ', to.f.brick.id + '.' + to.c
        if 'Param' == from.f.brick.I
          if 'F' == to.c
            @oscillator.frequency.value = from.f.brick.O
          #@todo gain on 'G'


#### `connect()`
Xx. 

      connect: (from, to) ->
        claud.log @id + '.' + from.c, 'connects to ', to.f.brick.id + '.' + to.c
        if 'Loudspeaker' == to.f.brick.I
          @oscillator.connect CheeSynth.ctx.destination
        if 'Param' == from.f.brick.I
          if 'F' == to.c
            @oscillator.frequency.value = from.f.brick.O
          #@todo gain on 'G'


#### `disconnect()`
Xx. 

      disconnect: (from, to) ->
        claud.log @id + '.' + from.c, 'disconnects from ', to.f.brick.id + '.' + to.c
        if 'Loudspeaker' == to.f.brick.I
          @oscillator.disconnect CheeSynth.ctx.destination


#### `render()`
Xx. 

      render: -> [
        '.=====.'
        '|     |'
        "F #{@id} F"
        '|     |'
        "'L===R'"
      ]




