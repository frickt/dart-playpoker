library poker_engine;

import "dart:math";
import "dart:html";


class Player{
  String name;
  bool human;
  List<Card> hand = [];
  List<Card> changing = [];
  String handValue;
  int pot = 10000;
  int status = 0;
  int encHand;

  /*
   * statuses:
   * 0 = idle
   * 1 = changing cards
   * 2 = final
   */

}

class Card{
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
    for( var x = 0; x<cardsMultiplicity.length; x++){
      encMultiplicity+=pow(cardsMultiplicity.values[x],2);
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



  showCards(Player player){
    String prefix;
    if(player.human){
      prefix='h';
    }
    else{
      prefix='c';
    }
    List slots = ['1','2','3','4','5'];
    for (var i = 0; i<5; i++){
      query('#$prefix${slots[i]}').style
      ..backgroundImage='url(${player.hand[i].cardImage()})'
      ..width='71px'
      ..height='96px';
    }





  }

  changeCards(Player player){
    for(var card in player.changing){
      var rm = player.hand.indexOf(card);
      player.hand.removeAt(rm);

    }
    this.serveHand(player);
    this.showCards(player);
    this.evaluateHand(player);

  }

  showdown(Player player, Player computer){
    this.showCards(computer);
  }

  String compareHands(Player player, Player computer){
    if(player.encHand>computer.encHand){
      return 'You won :-)';
    }
    else if(player.encHand==computer.encHand){
      return 'You both have the same kind so nobody won <em>(I know, pretty unfair, this comparing method should be improved!)</em>';
    }
    else{
      return 'You lost :-(';
    }
  }
}