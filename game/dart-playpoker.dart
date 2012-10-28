#import('dart:html');
#import('dart:math');

#import('../lib/poker_engine.dart');


main(){
  init();
  PokerEngine game = new PokerEngine();
  game.serveHand();

  query('#newHand').on.click.add(newHand(Event event){
    // not implemented yet
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

