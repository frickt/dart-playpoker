#import('dart:math');
#import('../lib/poker_engine.dart');

main(){
  PokerEngine game = new PokerEngine();
  Hand computer = new Hand();
  Hand human = new Hand();
  Card first = new Card(0,2);
  Card second = new Card(1,3);
  Card third = new Card(3,14);
  Card fourth = new Card(2,13);
  Card fifth = new Card(2,13);

  game.servedCards.add(fourth);

  assert(game.servedCards[0].nameOfCard() == fifth.nameOfCard());





}