Unicode characters used by this class:  
`U+2713`  CHECK MARK  
`U+2714`  HEAVY CHECK MARK  
`U+2718`  HEAVY BALLOT X  
`U+2b07`  DOWNWARDS BLACK ARROW  
`U+2b06`  UPWARDS BLACK ARROW  
`U+00B7`  MIDDLE DOT  


Define the `Test` class
-----------------------

    class Test
      toString: -> '[object Test]'

      jobs: []

      constructor: (opt={}) ->


#### `run()`
Run the tests and return the result.

      run: =>
        md = []
        tallies = [ 0, 0 ] # pass, fail
        double = null
        for job in @jobs
          switch toType job
            when 'function' # replace the previous `double`
              double = job(double)
            when 'string'   # eg a '- - -' rule or a section heading
              md.push job
            when 'array'    # tests in the form `[ runner, name, expect, actual ]`
              [ runner, name, expect, actual ] = job # dereference
              result = runner(expect, actual, double) # run the test
              if ! result
                md.push "\u2713 #{name}  " # Unicode CHECK MARK
                tallies[0]++ # pass tally
              else
                md.push "\u2718 #{name}  " # Unicode HEAVY BALLOT X
                md.push "    #{result}  "
                tallies[1]++ # fail tally

Generate a summary message.

          summary  = "  passed #{tallies[0]}/#{tallies[0] + tallies[1]} "
          summary += if tallies[1] then '\u2718' else '\u2714'

Return the result as a string. 

        md.unshift '<a href="#end" id="top">\u2b07</a>' + summary
        md.push  '\n<a href="#top" id="end">\u2b06</a>' + summary
        md.join  '\n'


#### `section()`
Add a section heading.

      section: (text) ->
        @jobs.push "\n\n#{text}\n-" + ( new Array(text.length).join '-' ) + '\n'


#### `custom()`
Schedule a custom test.

      custom: (tests, runner) ->
        for test,i in tests
          if 'function' == toType test
            @jobs.push test
          else
            @jobs.push [
              runner      # <function>  runner  Function which will run the test
              test        # <string>    name    A short description of the test
              tests[++_i] # <mixed>     expect  Defines a successful test
              tests[++_i] # <function>  actual  Produces the result to test
            ]
        @jobs.push '- - -' # http://daringfireball.net/projects/markdown/syntax#hr


#### `fail()`
Format a typical fail message.

      fail: (result, delivery, expect, types) ->
        if types
          result = "#{invisibles result} (#{toType result})"
          expect = "#{invisibles expect} (#{toType expect})"
        "#{invisibles result}\n    ...was #{delivery}, but expected...\n    #{invisibles expect}"


#### `invisibles()`
Convert to string, and reveal invisible characters. @todo not just space

      invisibles = (value) ->
        value.toString().replace /^\s+|\s+$/g, (match) ->
          '\u00b7' + (new Array match.length).join '\u00b7'


#### `throws()`
Expect `actual()` to throw an exception.

      throws: (tests) ->
        @custom tests, (expect, actual, double) =>
          error = false
          try actual(double) catch e then error = e.message
          if ! error
            "No exception thrown, expected...\n    #{expect}"
          else if expect != error
            @fail error, 'thrown', expect


#### `equal()`
Expect `actual()` and `expect` to be equal.

      equal: (tests) ->
        @custom tests, (expect, actual, double) =>
          error = false
          try result = actual(double) catch e then error = e.message
          if error
            "Unexpected exception...\n    #{error}"
          else if expect != result
            @fail result, 'returned', expect, (result + '' == expect + '')


#### `is()`
Expect `toType( actual() )` and `expect` to be equal.

      is: (tests) ->
        @custom tests, (expect, actual, double) =>
          error = false
          try result = actual(double) catch e then error = e.message
          if error
            "Unexpected exception...\n    #{error}"
          else if expect != toType result
            @fail "type #{toType result}", 'returned', "type #{expect}"


#### `toType()`
To detect the difference between 'null', 'array', 'regexp' and 'object' types, 
we use [Angus Croll’s one-liner](http://goo.gl/WlpBEx) instead of JavaScript’s 
familiar `typeof` operator.

      toType = (x) ->
        ({}).toString.call(x).match(/\s([a-z|A-Z]+)/)[1].toLowerCase()





Instantiate `test`
------------------

Create an instance of `Test`, to add tests to.

    test = new Test


Expose the `test` instance’s `run()` method as a property of `CheeSynth`. This 
will allow tests to be run using `CheeSynth.runTest()`. 

    CheeSynth.runTest = test.run


