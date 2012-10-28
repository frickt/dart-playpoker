#library('poker_engine');
#import('dart:math');
#import('dart:html');

class Card {
  // r = rank
  // s = suite
  int r,s;

  var suiteNames = ['Clubs','Diamonds','Hearts','Spades'];
  var rankNames = ['None','None', '2', '3', '4', '5', '6', '7','8', '9', '10', 'Jack', 'Queen', 'King','Ace'];


  Card(this.s,this.r){
    //print('Served a ${this.nameOfCard()}');

  }

  String nameOfCard(){
    return '${rankNames[this.r]} of ${suiteNames[this.s]}';
  }

  String toString() => this.nameOfCard();

  String cardImage() => 'cards/${suiteNames[this.s][0].toLowerCase()}${this.r}.png';


}

class Hand {
String handValue;
bool hidden;
List<Card> cards = [];

}

class PokerEngine {

  List<Card> servedCards=[];

  serveHand(){
    Hand human = new Hand();
    Hand computer = new Hand();
    human.hidden = false;
    computer.hidden = true;

    for (var player in [human,computer]){
      while(player.cards.length < 5){
        Card inCard = pickCard();
        if (beenServed(inCard) == false){
          servedCards.add(inCard);
          player.cards.add(inCard);
        }

      }
    }

  showCards(human);
  query("#human").text=evaluateHand(human);



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


  showCards(Hand player){
    List slots = ['h1','h2','h3','h4','h5'];
    for (var i = 0; i<5; i++){
      query('#${slots[i]}').style
      ..backgroundImage='url(${player.cards[i].cardImage()})'
      ..width='71px'
      ..height='96px';
    }
    print(player.cards);


  }


 String evaluateHand(Hand player){
   Map<int,int> cardsMultiplicity = new Map();
   for(var card in player.cards){
     if(cardsMultiplicity[card.r]==null){
       cardsMultiplicity[card.r]=1;
     }
     else{
       cardsMultiplicity[card.r]++;
     }
   }

   int encMultiplicity=0;
   for( var x = 0; x<cardsMultiplicity.getValues().length; x++){
     encMultiplicity+=pow(cardsMultiplicity.getValues()[x],2);
   }

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

 void allOnes(Hand player){
   List R = [player.cards[0].r,player.cards[1].r,player.cards[2].r,player.cards[3].r,player.cards[4].r];
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
   }
   else{
     player.handValue='Straight';
   }
 }
 else if (R[4]==14 && R[0]==2 && R[3]==5){
   if(this.isFlush(player)){
     player.handValue='Straight Flush';
   }
   else{
     player.handValue='Straight';
   }
 }
 else {
   if (this.isFlush(player)){
     player.handValue='Flush';
   }
   else{
     player.handValue='High card';
   }
 }


 }


 bool isFlush(Hand player){
   List allSuites = [player.cards[0].s,player.cards[1].s,player.cards[2].s,player.cards[3].s,player.cards[4].s];
   for(var i=0;i<allSuites.length-1;i++){
     if(allSuites[i]!=allSuites[i+1]){
       return false;
     }
   }
   return true;
 }

}

