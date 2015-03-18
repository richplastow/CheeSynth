CheeSynth
=========




Define the `CheeSynth` class
----------------------------

    class CheeSynth
      toString: -> '[object CheeSynth]'




Define the constructor
----------------------

      constructor: (opt) ->




Export `CheeSynth`
------------------

Allow CheeSynth to be accessed from anywhere, eg using `cs = new CheeSynth()`.  
@todo export for RequireJS etc

    window.CheeSynth = CheeSynth
