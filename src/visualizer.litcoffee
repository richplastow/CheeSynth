Visualizer
==========

`Visualizer` is a BrickAudio which analyses audio, displays it in a simple way, 
and outputs a summary. 




Define the `Visualizer` class
-----------------------------

    class Visualizer extends BrickAudio
      I: 'Visualizer'




Define the constructor
----------------------

      constructor: (opt={}) ->
        super
        @isAnalyzing = false
        @analyzer = CheeSynth.ctx.createAnalyser()
        @analyzer.fftSize = 512
        @bufferLength = @analyzer.frequencyBinCount
        @dataArray = new Uint8Array @bufferLength




Define public methods
---------------------

#### `connect()`
Xx. 

      connect: (from, to) ->
        #claud.log @id + '.' + from.c, 'connects to ', to.f.brick.id + '.' + to.c
        if 'Wave' == from.f.brick.I
          @isAnalyzing = true
          from.f.brick.oscillator.connect @analyzer
        if 'Loudspeaker' == to.f.brick.I
          @analyzer.connect CheeSynth.ctx.destination


#### `disconnect()`
Xx. 

      disconnect: (from, to) ->
        #claud.log @id + '.' + from.c, 'disconnects from ', to.f.brick.id + '.' + to.c
        if 'Wave' == from.f.brick.I
          @isAnalyzing = false
          from.f.brick.oscillator.disconnect @analyzer
        if 'Loudspeaker' == to.f.brick.I
          @analyzer.disconnect CheeSynth.ctx.destination


#### `render()`
Xx. 

      render: ->
        if ! @isAnalyzing
          return [
            '.======L===R======.'
            "|                 |"
            "|                 |"
            "|                 |"
            "|       #{@id}       |"
            "'======L===R======'"
          ]

        @analyzer.getByteTimeDomainData @dataArray
        @wlt = [] # waveform left top
        @wlc = [] # waveform left center
        @wlb = [] # waveform left bottom
        chunk = @dataArray.length / 16
        for i in [0..15]
          high = 128
          low  = 128
          for j in [i*chunk..(i+1)*chunk-1]
            data = @dataArray[j]
            high = Math.max high, data
            low  = Math.min low , data

          @wlt[i] = @wlc[i] = @wlb[i] = ' ' # no signal

          if      213 < high
            @wlc[i] = '╹'; @wlt[i] = '╏'
          else if 170 < high
            @wlc[i] = '╹'; @wlt[i] = '╻'
          else if 128 < high
            @wlc[i] = '╹'

          if      42  > low
            (@wlc[i] = if '╹' == @wlc[i] then '╏' else '╻'); @wlb[i] = '╏'
          else if 85  > low
            (@wlc[i] = if '╹' == @wlc[i] then '╏' else '╻'); @wlb[i] = '╹'
          else if 128 > low
            @wlc[i] = if '╹' == @wlc[i] then '╏' else '╻'

        [
          '.======L===R======.'
          "| #{@wlt.join ''}|"
          "|l#{@wlc.join ''}|"
          "| #{@wlb.join ''}|"
          "|       #{@id}       |"
          "'======L===R======'"
        ]

        # ⎺⎻–⎼⎽ _-



