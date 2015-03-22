Export CheeSynth
================


Allow CheeSynth to be accessed from anywhere, eg using `cs = new CheeSynth()`.  
@todo export for RequireJS etc

    window.CheeSynth = CheeSynth


Make the various `Brick` subclasses available to `CheeSynth.createBrick()`. 

    brickClasses = 
      Brick:       Brick
      BrickAudio:  BrickAudio
      Loudspeaker: Loudspeaker
      Wave:        Wave
