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
      this.cardScore = this.cardSuit = 'null'
      this.cardColor = 'gray'

      for node, i in this.impl.attributes
        if node.name is 'card-name'
          [this.cardScore, this.cardSuit] = node.value.split('')
          this.cardColor = colorMap[this.cardSuit]
          this.cardSuit = suitMap[this.cardSuit]
          this.cardScore = scoreMap[this.cardScore]
  }