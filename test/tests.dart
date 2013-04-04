import 'package:unittest/unittest.dart';
import 'package:unittest/html_config.dart';
import 'package:dart_playpoker/playpoker.dart';

main() {
  useHtmlConfiguration();

  Game g = new Game();
  g.human = g.createHuman();
  g.computer = g.createComputer();

  //TODO: Hands:
  List<Card> highCard10Diamonds = [
    new Card(1,3),
    new Card(1,10),
    new Card(0,5),
    new Card(3,2),
    new Card(2,4)];

  List<Card> highCardAceClubs = [
    new Card(0,14),
    new Card(1,13),
    new Card(0,4),
    new Card(2,5),
    new Card(0,9)];

  List<Card> pair2clubs2hearts = [
    new Card(0,2),
    new Card(2,2),
    new Card(0,3),
    new Card(2,9),
    new Card(0,10)];

  List<Card> pair5clubs5diamonds = [
    new Card(0,5),
    new Card(1,5),
    new Card(0,4),
    new Card(2,6),
    new Card(0,9)];

  List<Card> pair2diamonds2spades = [
    new Card(1,2),
    new Card(3,2),
    new Card(0,14),
    new Card(0,3),
    new Card(3,6)];

  List<Card> twoPairs4and8 = [
    new Card(1,4),
    new Card(2,4),
    new Card(1,8),
    new Card(2,8),
    new Card(1,13)];

  List<Card> threeK = [
    new Card(0,13),
    new Card(1,13),
    new Card(2,13),
    new Card(3,8),
    new Card(3,2)];

  List<Card> fourOfAKindAce = [
    new Card(0,14),
    new Card(1,14),
    new Card(2,14),
    new Card(3,14),
    new Card(0,5)];

  group('Cards',(){
    //TODO
  });

  test("Hand values",(){
    assignHands(g, pair2clubs2hearts, highCard10Diamonds);
    expect(g.human.handValue, equals("Pair"));
    expect(g.computer.handValue, equals("High Card"));
    assignHands(g, fourOfAKindAce, threeK);
    expect(g.human.handValue, equals("Four Of A Kind"));
    expect(g.computer.handValue, equals("Three Of A Kind"));
  });

  group('Different kind of hands comparison',(){
    test("Human player wins",(){
      // Human: pair 2 of Clubs, 2 of Hearts
      // Computer: high card
      assignHands(g, pair2clubs2hearts, highCard10Diamonds);
      expect(g.compareHands(),equals({"humanWinner":true,"reason":"You have a higher hand."}));
      assignHands(g, fourOfAKindAce, threeK);
      expect(g.compareHands(),equals({"humanWinner":true,"reason":"You have a higher hand."}));

    });

    test("Computer player wins",(){
      assignHands(g, highCard10Diamonds, pair2clubs2hearts);
      expect(g.compareHands(),equals({"humanWinner":false,"reason":"You have a lower hand."}));
      assignHands(g, threeK, fourOfAKindAce);
      expect(g.compareHands(),equals({"humanWinner":false,"reason":"You have a lower hand."}));

    });

  });


  group('Same kind of hands comparison',(){
    group('High card',(){
      test('Human player wins',(){
        assignHands(g, highCardAceClubs, highCard10Diamonds);
        expect(g.compareHands(), equals({"humanWinner":true,"reason":"You have a higher High Card"}));
      });
      test('Computer player wins',(){
        assignHands(g, highCard10Diamonds, highCardAceClubs);
        expect(g.compareHands(), equals({"humanWinner":false,"reason":"You have a lower High Card"}));
      });
    });
    group('Pair',(){
      test('Human player wins',(){
        assignHands(g, pair5clubs5diamonds, pair2clubs2hearts);
        expect(g.compareHands(), equals(
            {"humanWinner":true,"reason":"You have a higher Pair."}
            ));
      });
      test('Computer player wins',(){
        assignHands(g,pair2clubs2hearts, pair5clubs5diamonds);
        expect(g.compareHands(), equals(
            {"humanWinner":false,"reason":"You have a lower Pair."}
            ));
      });
      test('Human player wins because has Spades',(){
        assignHands(g, pair2diamonds2spades, pair2clubs2hearts);
        print(g.human.hand);
        print(g.human.handValue);
        print(g.computer.hand);
        print(g.computer.handValue);

        expect(g.compareHands(), equals(
            {"humanWinner":true,"reason":"You have the card of Spades."}
        ));
      });
      test('Computer player wins because has Spades',(){
        assignHands(g, pair2clubs2hearts, pair2diamonds2spades);
        expect(g.compareHands(), equals(
            {"humanWinner":false,"reason":"Computer has the card of Spades."}
        ));
      });
    });


    //TODO: Two Pairs
    //TODO: Three Of A Kind
    //TODO: Fullhouse
    //TODO: Four Of A Kind
    //TODO: Straights


  });

}

void assignHands(Game g, List humanHand, List computerHand) {
  g.human.hand=[];
  g.computer.hand=[];
  g.human.hand.addAll(humanHand);
  g.computer.hand.addAll(computerHand);
  g.evaluateHand(g.human);
  g.evaluateHand(g.computer);
}