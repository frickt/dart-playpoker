part of playpoker;

class Game {
  int state;

  Player human;
  Player computer;

  List<Card> servedCards=[];

  Player createHuman() {
    print("Creating the human player");
    Player h = new Player();
    h.changing=[];
    h.hand=[];
    h.human=true;
    return h;
  }

  Player createComputer() {
    Player c = createHuman();
    print("Assigning human=false to player");
    c.human=false;
    return c;
  }

  void init() {
    print("Resetting initial values");
    state = 0;
    servedCards=[];
    human.hand=[];
    computer.hand=[];
    human.changing=[];
    computer.changing=[];
  }

  void serveHand(Player player){
    while(player.hand.length < 5){
        Card inCard = pickCard();
        if (beenServed(inCard) == false){
          servedCards.add(inCard);
          player.hand.add(inCard);
        }
      }
   }


  Card pickCard(){
    int  randomSuite, randomRank;
    var rnd = new Random();
    randomSuite = rnd.nextInt(4);
    randomRank = 2 + rnd.nextInt(13);

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


  // Evaluation!
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
    R.sort((a,b) {
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


  // State switchers
  void state0() {
    Gui.init(this);
    state=0;
    state1();
  }

  void state1() {
    state=1;
    serveHand(human);
    serveHand(computer);
    Gui.showCards(this);
    evaluateHand(human);
    evaluateHand(computer);
    Gui.updateStatusBar('You have a <b>${human.handValue}</b>. You can now change up to 4 cards or jump to showdown');
  }

  void state2() {
    print("You have to change your cards");
    state=2;
    // remove cards
    for ( Card card in human.changing ) {
      human.hand.remove(card);
    }

    // fill the hand with new cards
    serveHand(human);
    print(human.hand);
    evaluateHand(human);
    state3();
  }

  void state3() {
    state=3;
    print("You have to show down");
    Gui.showCards(this, showdown:true);
    Gui.resetCardPosition();
    Gui.hideShowdownButton();
    Gui.updateStatusBar('You have a <b>${human.handValue}</b>.');
  }


}

class Card {
  // r = rank
  // s = suite
  int r,s;

  var suiteNames = ['Clubs','Diamonds','Hearts','Spades'];
  var rankNames = ['None','None', '2', '3', '4', '5', '6', '7','8', '9', '10', 'Jack', 'Queen', 'King','Ace'];


  Card(this.s,this.r) { }

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
  return false;
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
  return false;
  }

  operator ==(Card other) {
    if (this.r == other.r && this.s == other.s) return true;
    return false;
  }

}

class Player{
  String name;
  bool human;
  List<Card> hand = [];
  List<Card> changing = [];
  String handValue;
  int pot = 10000;
  int encHand;
}