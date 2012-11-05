import "dart:math";
part '../game/poker_engine.dart';


//import "dart:html";

main(){
  Player player = new Player();
  Player computer = new Player();
  PokerEngine game = new PokerEngine();


  // HIGH CARD
  player.hand = [new Card(0,2),new Card(1,3),new Card(2,14),new Card(1,13),new Card(2,12)];
  computer.hand = [new Card(0,3),new Card(0,4), new Card(3,14), new Card(2,5), new Card(1,9)];

  game.evaluateHand(player);
  game.evaluateHand(computer);

  print(game.compareHands(player, computer));


  /* PAIR
  *  player's pair is: 5 of Clubs, 5 of Diamonds
  *  computer's pair is: 4 of Diamonds, 4 of Clubs
  */

  player.hand = [new Card(0,5),new Card(1,5),new Card(2,14),new Card(1,13),new Card(2,12)];
  computer.hand = [new Card(2,5),new Card(0,4), new Card(3,14), new Card(3,5), new Card(1,9)];

  game.evaluateHand(player);
  game.evaluateHand(computer);

  print(player.handValue);
  print(computer.handValue);
  print(player.hand);
  print(computer.hand);
  print(game.compareHands(player, computer));


}