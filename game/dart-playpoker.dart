#import('dart:html');
#import('dart:math');

#import('../lib/poker_engine.dart');


main(){
  init();

  Player player = new Player();
  Player computer = new Player();

  player.name="Human player";
  computer.human=false;

  newHand(player);

  query('#newHand').on.click.add(function(Event event){
    newHand(player);
  });


}

void init(){
  List slots = ['c1','c2','c3','c4','c5','h1','h2','h3','h4','h5'];
  for (var slot in slots){
    query('#$slot').style
    ..backgroundImage='url(img/deck.png)'
    ..width='71px'
    ..height='96px';
  }

}

newHand(Player player){
  PokerEngine game = new PokerEngine();
  game.serveHand(player);
  game.showCards(player);
  game.evaluateHand(player);
  query("#human").text=player.handValue;

}

