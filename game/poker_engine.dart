class Player{
  String name;
  bool human;
  List<Card> hand = [];
  List<Card> changing = [];
  String handValue;
  int pot = 10000;
  int status = 0;
  int encHand;
}

class Card{
  // r = rank
  // s = suite
  int r,s;

  var suiteNames = ['Clubs','Diamonds','Hearts','Spades'];
  var rankNames = ['None','None', '2', '3', '4', '5', '6', '7','8', '9', '10', 'Jack', 'Queen', 'King','Ace'];


  Card(this.s,this.r) {
    print(nameOfCard());
  }

  String nameOfCard(){
    return '${rankNames[this.r]} of ${suiteNames[this.s]}';
  }

  String toString() => this.nameOfCard();

  String cardImage() => 'cards/${suiteNames[this.s][0].toLowerCase()}${this.r}.png';

  operator >(Card other) {
    if ( this.r > other.r){
    return true;
  }
  else if (this.r == other.r){
    if ( this.s > other.s){
      return true;
      }
    }
  else{
    return false;
  }
  }

  operator <(Card other) {
    if ( this.r < other.r){
    return true;
  }
  else if (this.r == other.r){
    if ( this.s < other.s){
      return true;
      }
    }
  else{
    return false;
  }
  }

  operator ==(Card other) {
    if (this.r == other.r && this.s == other.s) {return true;} else {return false;}
  }
}

class PokerEngine{
  List<Card> servedCards=[];

  serveHand(Player player){
    while(player.hand.length < 5){
        Card inCard = pickCard();
        if (beenServed(inCard) == false){
          servedCards.add(inCard);
          player.hand.add(inCard);
        }
      }

    player.status++;
   }


  Card pickCard(){
    int  randomSuite, randomRank;
    var rnd = new Random();
    randomSuite = rnd.nextInt(4);
    while(true){
      randomRank = rnd.nextInt(15);
      if(randomRank>1){
        break;
      }
    }

    Card giveCard = new Card(randomSuite,randomRank);
    return giveCard;
  }

  bool beenServed(Card toAdd){
    for (var card in servedCards){
      if(card.nameOfCard() == toAdd.nameOfCard()){
        return true;
      }
    }
    return false;
  }

  String evaluateHand(Player player){
    Map<int,int> cardsMultiplicity = new Map();
    for(var card in player.hand){
      if(cardsMultiplicity[card.r]==null){
        cardsMultiplicity[card.r]=1;
      }
      else{
        cardsMultiplicity[card.r]++;
      }
    }

    int encMultiplicity=0;

    for (var multi in cardsMultiplicity.values){
      encMultiplicity+=pow(multi,2);
    }

    player.encHand = encMultiplicity;

    switch(encMultiplicity){
      case 5:
        allOnes(player);
        break;
      case 7:
        player.handValue='Pair';
        break;
      case 11:
        player.handValue='Three of a kind';
        break;
      case 9:
        player.handValue='Two pairs';
        break;
      case 13:
        player.handValue='Fullhouse';
        break;
      case 17:
        player.handValue='Four of a kind';
        break;
    }

    return player.handValue;

  }

  allOnes(Player player){
    List R = [player.hand[0].r,player.hand[1].r,player.hand[2].r,player.hand[3].r,player.hand[4].r];
    R.sort(compare(a,b) {
      if (a == b) {
        return 0;
      }
      else if (a > b) {
        return 1;
      }
      else {
        return -1;
      }
    });

    if(R[4]==R[0]+4){
      if(this.isFlush(player)){
        player.handValue='Straight Flush';
        player.encHand=18;
      }
      else{
        player.handValue='Straight';
        player.encHand=12;
      }
    }
    else if (R[4]==14 && R[0]==2 && R[3]==5){
      if(this.isFlush(player)){
        player.handValue='Straight Flush';
        player.encHand=18;
      }
      else{
        player.handValue='Straight';
        player.encHand=12;
      }
    }
    else {
      if (this.isFlush(player)){
        player.handValue='Flush';
        player.encHand=14;
      }
      else{
        player.handValue='High card';
        player.encHand=1;
      }
    }
  }


  bool isFlush(Player player){
    List allSuites = [player.hand[0].s,player.hand[1].s,player.hand[2].s,player.hand[3].s,player.hand[4].s];
    for(var i=0;i<allSuites.length-1;i++){
      if(allSuites[i]!=allSuites[i+1]){
        return false;
      }
    }
    return true;
  }

  changeCards(Player player){
    for(var card in player.changing){
      var rm = player.hand.indexOf(card);
      player.hand.removeAt(rm);
    }

    this.serveHand(player);
    showCards(player);
    this.evaluateHand(player);
  }

  showdown(Player player, Player computer){
    showCards(computer);
  }

  String compareHands(Player player, Player computer){
    if(player.encHand>computer.encHand){
      return 'You won :-)';
    }
    else if(player.encHand==computer.encHand){
      switch(player.encHand){
        case 1:
          return this.compareHighCard(player,computer);
        case 7:
          return this.comparePair(player,computer);
      }
    }
    else{
      return 'You lost :-(';
    }
  }

  compareHighCard(Player player, Player computer) {

    Card playerMax = new Card(0,0);
    Card computerMax = new Card(0,0);

    for(var card in player.hand){
      if(card>playerMax){
        playerMax = card;
      }
    }

    for (var card in computer.hand){
      if(card>computerMax){
        computerMax = card;
      }
    }

    if(playerMax>computerMax){
      return 'You win';
    }
    else{
      return 'You lost';
    }
  }
  comparePair(Player player,Player computer){

    Map playerPair= new Map();
    for (var card in player.hand){
      if(playerPair[card.r]==null){
        playerPair[card.r]=[card];
      }
      else{
        playerPair[card.r].add(card);
      }
    }

    Map computerPair= new Map();
    for (var card in computer.hand){
      if(computerPair[card.r]==null){
        computerPair[card.r]=[card];
      }
      else{
        computerPair[card.r].add(card);
      }
    }



    int playerPairRank;
    List playerPairValue = [];
    playerPair.forEach((k,v){
      if(v.length==2){
        playerPairRank=k;
        playerPairValue=v;
      }
    });

    int computerPairRank;
    List computerPairValue = [];
    computerPair.forEach((k,v){
      if(v.length==2){
        computerPairRank=k;
        computerPairValue=v;
      }
    });


    if(playerPairRank>computerPairRank){
      return 'You have higher pair, you won :-)';
    }
    else if(playerPairRank<computerPairRank){
      return 'You have lower pair, you lost :-(';
    }
    else{
      for (var searchThree in playerPairValue){
        if(searchThree.s==3){return 'You have Spades, you won.';}
        return 'Computer has Spades, you lost.';
      }
    }

  }

}