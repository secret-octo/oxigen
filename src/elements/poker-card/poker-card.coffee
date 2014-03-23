do -> 
  suitMap = {
    H: '♥'
    h: '♥'
    D: '♦'
    d: '♦'
    C: '♣'
    c: '♣'
    S: '♠'
    s: '♠'
  }

  colorMap = {
    H: 'red'
    h: 'red'
    D: 'red'
    d: 'red'
    C: 'black'
    c: 'black'
    S: 'black'
    s: 'black'
  }

  scoreMap = {
    '1': ' 1'
    '2': ' 2'
    '3': ' 3'
    '4': ' 4'
    '5': ' 5'
    '6': ' 6'
    '7': ' 7'
    '8': ' 8'
    '9': ' 9'
    T: '10'
    t: '10'
    J: ' J'
    j: ' J'
    Q: ' Q'
    q: ' Q'
    K: ' K'
    A: ' A'
    a: ' A'


  }

  Polymer 'poker-card', {
    ready: ->
      @cardScore = @cardSuit = '#'
      @cardColor = 'gray'

      for node, i in @attributes
        if node.name is 'value'
          [@cardScore, @cardSuit] = node.value.split('')
          @cardColor = colorMap[@cardSuit]
          @cardSuit = suitMap[@cardSuit]
          @cardScore = scoreMap[@cardScore]
  }