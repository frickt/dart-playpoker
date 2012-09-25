class Hand {
  num player;
  String hand;
  Card slot1,slot2,slot3,slot4,slot5;
/*
Nasty workaround
*/
  static String notInDeck = '';

  serveHand(){
    List servedCards=new List();
    List servedPlainCards =  new List();

    while(servedCards.length<5){
      Card receivedCard = pickCard();
      if(servedPlainCards.indexOf('${receivedCard.s},${receivedCard.r}')==-1 && !notInDeck.contains('${receivedCard.s},${receivedCard.r}|')){
        servedPlainCards.add('${receivedCard.s},${receivedCard.r}');
        servedCards.add(receivedCard);
        notInDeck='$notInDeck''${receivedCard.s},${receivedCard.r}|';
      }
    }

    this.slot1=servedCards[0];
    this.slot2=servedCards[1];
    this.slot3=servedCards[2];
    this.slot4=servedCards[3];
    this.slot5=servedCards[4];
    fdb(notInDeck);
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

  lay(){
    String slotImgPrefix,cardImgPrefix;
    fdb('laying cards for player ${this.player}');
    if(player==1){
      slotImgPrefix='h';
    }
    else
    {
      slotImgPrefix='c';
    }

    String generateCardImgPath(Card whichCard){
      switch(whichCard.s){
        case 0:
        cardImgPrefix='c';
        break;
        case 1:
        cardImgPrefix='d';
        break;
        case 2:
        cardImgPrefix='h';
        break;
        case 3:
        cardImgPrefix='s';
        break;
      }
      String cardImgPath='cards/$cardImgPrefix${whichCard.r}\.png';
      return cardImgPath;
    }

    document.query('#$slotImgPrefix\1').src=generateCardImgPath(this.slot1);  
    document.query('#$slotImgPrefix\2').src=generateCardImgPath(this.slot2);
    document.query('#$slotImgPrefix\3').src=generateCardImgPath(this.slot3);
    document.query('#$slotImgPrefix\4').src=generateCardImgPath(this.slot4);
    document.query('#$slotImgPrefix\5').src=generateCardImgPath(this.slot5);
  }

  String evaluate(){
    Map<int,int> cardsMultiplicity = new Map();
    List allRanks = [this.slot1.r,this.slot2.r,this.slot3.r,this.slot4.r,this.slot5.r];
    fdb('Starting hand eval...');
    for (var x = 0; x<allRanks.length; x++) {
      if(cardsMultiplicity[allRanks[x]] == null){
        //Create
        cardsMultiplicity[allRanks[x]]=1;
        }
      else
      {
        //Update
        cardsMultiplicity[allRanks[x]]++;
      }
    }

    int encMultiplicity = 0;
    for( var x = 0; x<cardsMultiplicity.getValues().length; x++){
      encMultiplicity+=pow(cardsMultiplicity.getValues()[x],2);
    }

    fdb('Encoded multiplicity: $encMultiplicity');

    //Actual logic:
    switch(encMultiplicity){
      case 5:
        this.allOnes();
        break;
      case 7:
        this.hand='Pair';
        break;
      case 11:
        this.hand='Three of a kind';
        break;
      case 9:
        this.hand='Two pairs';
        break;
      case 13:
        this.hand='Fullhouse';
        break;
      case 17:
        this.hand='Four of a kind';
        break;
    }

    updateStatus(this.player,this.hand);
    return this.hand;
  }

  void allOnes(){
  List R=[this.slot1.r,this.slot2.r,this.slot3.r,this.slot4.r,this.slot5.r];
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
    if(this.isFlush()){
      this.hand='Straight Flush';
    }
    else{
      this.hand='Straight';
    }
  }
  else if (R[4]==14 && R[0]==2 && R[3]==5){
    if(this.isFlush()){
      this.hand='Straight Flush';
    }
    else{
      this.hand='Straight';
    }
  }
  else {
    if (this.isFlush()){
      this.hand='Flush';
    }
    else{
      this.hand='High card';
    }
  }
  }

  bool isFlush(){
    List allSuites = [this.slot1.s,this.slot2.s,this.slot3.s,this.slot4.s,this.slot5.s];
    for(var i=0;i<allSuites.length-1;i++){
      if(allSuites[i]!=allSuites[i+1]){
        return false;
        }
      }
    return true;
  }

  void sort(){}
  int compare(Hand opponent){}
}