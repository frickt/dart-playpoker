import "dart:math";
part 'file:/Users/dawson/workspace/github/dart-playpoker/lib/poker_engine.dart';

main(){

  assert(new Card(3,14) == new Card(3,14));
  assert(new Card(1,3) != new Card(2,3));
  assert(new Card(1,3) < new Card(1,4));
  assert(new Card(3,14) > new Card(3,13));

}