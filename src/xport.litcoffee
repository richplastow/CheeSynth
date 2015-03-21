Assemble and export CheeSynth
=============================


Allow various subclasses to be accessed on the CheeSynth class, eg:  
`new CheeSynth.Brick()` 

    CheeSynth.Brick   = Brick
    #CheeSynth.Fixture = Fixture


Allow CheeSynth to be accessed from anywhere, eg using `cs = new CheeSynth()`.  
@todo export for RequireJS etc

    window.CheeSynth = CheeSynth
