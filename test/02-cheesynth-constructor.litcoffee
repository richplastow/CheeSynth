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

      "`cs.width` is zero by default"
      0
      -> ( new CheeSynth() ).width
      
      "`cs.height` is zero by default"
      0
      -> ( new CheeSynth() ).height
      
      "`cs.width` can be set"
      3
      -> ( new CheeSynth({ width:3 }) ).width

      "`cs.height` can be set"
      4
      -> ( new CheeSynth({ height:4}) ).height


    ]
