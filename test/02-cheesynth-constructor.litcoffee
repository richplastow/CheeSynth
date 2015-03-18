Xx.

    test.section "Constructor"

    test.is [

      "Instantiate with no arguments"
      'object'
      -> new CheeSynth()

    ]

    test.equal [

      "`toString()` as expected"
      '[object CheeSynth]'
      -> ( new CheeSynth() ).toString()

    ]
