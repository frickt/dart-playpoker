library playpoker;

import 'dart:html';
import 'dart:math';

part '../lib/gui.dart';
part '../lib/poker_engine.dart';

main(){

  Player player = new Player();
  Player computer = new Player();

  player.name="Human player";
  player.human=true;
  computer.name="Computer";
  computer.human=false;

  init(player,computer);

  Map toggled = initCardSelection(player);
  newHand(player,computer,toggled);

  query('#newHand').on.click.add(function(Event event){
    newHand(player,computer,toggled);
  });

  query('#showdown').on.click.add(function(Event event){
    manageShowdownButton(player, computer, toggled, clicked: true);
  });
}

void init(Player player, Player computer){
  List<String> slots = ['c1','c2','c3','c4','c5','h1','h2','h3','h4','h5'];
  for (var slot in slots){
    query('#$slot').style
    ..backgroundImage='url(web/img/deck.png)'
    ..width='71px'
    ..height='96px';
  }
}

void newHand(Player player, Player computer, Map toggled){
  init(player,computer);
  player.status = 0;

  player.hand=[];
  computer.hand=[];
  player.changing=[];

  resetCardsPosition(toggled);

  query('#showdown').style.visibility='visible';
  query('#showdown').style.display='inline';

  PokerEngine game = new PokerEngine();
  game.serveHand(player);
  player.status++;
  showCards(player);
  game.evaluateHand(player);

  game.serveHand(computer);
  game.evaluateHand(computer);

  query("#status").innerHTML=updateStatus(player,computer,game);

  player.gameInstance = game;

  manageShowdownButton(player, computer, toggled, game: game );

  for(var i = 0; i < 5; i++)  toggled[i] = false;
}