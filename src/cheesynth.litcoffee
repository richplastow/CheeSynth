CheeSynth
=========




Define the `CheeSynth` class
----------------------------

    class CheeSynth
      toString: -> '[object CheeSynth]'


Define the constructor
----------------------

      constructor: (opt) ->
        @el         = opt.el
        @width      = opt.width
        @height     = opt.height
        @fixtures   = []




Define public methods
---------------------

#### `add()`
Xx. 

      add: (x, y, component) ->
        @fixtures.push fixture = new Fixture x, y, component
        fixture


#### `render()`
Xx. 

      render: ->

Create the output-array, which acts as the background for Components. 

        line = '· ' + (new Array @width / 2 ).join '· '
        out = for row in [1..@height] then line

Add each Component

        for fixture in @fixtures then draw fixture, out

        @el.innerHTML = out.join '\n'




Define private methods
----------------------

#### `draw()`
Xx. 

      draw = (fixture, out) ->
        x = fixture.x
        y = fixture.y
        rendered = fixture.component.render()
        for rline,i in rendered
          oline = out[y+i]
          if ! oline then throw new Error "#{fixture.component} exceeds height!"
          out[y+i] = "#{oline.substr 0, x}#{rline}#{oline.substr x+rline.length}"
        undefined




Define private classes
----------------------

#### `Fixture`
Xx. 

      class Fixture
        constructor: (@x, @y, @component) ->




Export `CheeSynth`
------------------

Allow CheeSynth to be accessed from anywhere, eg using `cs = new CheeSynth()`.  
@todo export for RequireJS etc

    window.CheeSynth = CheeSynth

