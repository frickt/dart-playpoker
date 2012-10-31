import 'dart:math';
import '../lib/poker_engine.dart';


main(){
  Player human = new Player();
  human.name="Dawson";

  PokerEngine game = new PokerEngine();
  game.serveHand(human);
  print(human.hand);
  print(game.servedCards);
  game.evaluateHand(human);
  print(human.handValue);
}