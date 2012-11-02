import 'dart:html';
import 'dart:math';

import '../lib/poker_engine.dart';


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



}

void init(Player player, Player computer){
  List<String> slots = ['c1','c2','c3','c4','c5','h1','h2','h3','h4','h5'];
  for (var slot in slots){
    query('#$slot').style
    ..backgroundImage='url(img/deck.png)'
    ..width='71px'
    ..height='96px';
  }

}

newHand(Player player, Player computer, Map toggled){
  init(player,computer);

  player.status = 0;
  player.hand=[];
  computer.hand=[];
  player.changing=[];

  resetCardsPosition(toggled);

  PokerEngine game = new PokerEngine();
  game.serveHand(player);
  game.showCards(player);
  game.evaluateHand(player);

  game.serveHand(computer);
  game.evaluateHand(computer);

  query("#status").innerHTML=updateStatus(player,computer,game);


  Function bindChangeFunction;
  bindChangeFunction = (e){
    query('#change').on.click.remove(bindChangeFunction);
    game.changeCards(player);
    resetCardsPosition(toggled);
    query('#change').style.visibility='hidden';
    query('#change').style.display='none';
    query("#status").innerHTML=updateStatus(player,computer,game);
    game.showdown(player,computer);
    };

  query('#change').on.click.remove(bindChangeFunction);
  query('#change').on.click.add(bindChangeFunction );

  query('#change').style.visibility='hidden';
  query('#change').style.display='none';




  for(var i = 0; i < 5; i++){
    toggled[i] = false;
  }

}


resetCardsPosition(Map toggled){
  query('#h1').style.marginTop='0px';
  query('#h2').style.marginTop='0px';
  query('#h3').style.marginTop='0px';
  query('#h4').style.marginTop='0px';
  query('#h5').style.marginTop='0px';

}

initCardSelection(Player player){



  Map<int,String> slots = new Map();
  Map<int,bool> toggled = new Map();

  slots[0] = 'h1';
  slots[1] = 'h2';
  slots[2] = 'h3';
  slots[3] = 'h4';
  slots[4] = 'h5';

  for(var i = 0; i < 5; i++){
    toggled[i] = false;
  }


  for (var i = 0; i<slots.length; i++){
    query('#${slots[i]}').on.click.add(function(Event event){
      toggleCard(player,i,toggled, slots);
    });
  }

  return toggled;
}


toggleCard(Player player, int slot, Map toggled, Map slots){


  if(player.status == 1){

  var margin;
  toggled[slot]= !toggled[slot];

  if(toggled[slot]){
    margin = "-15px";
    player.changing.add(player.hand[slot]);

  }
  else{
     margin = "0px";
     var rmIndex = player.changing.indexOf(player.hand[slot]);
     player.changing.removeAt(rmIndex);
  }

  if(player.changing.length==5){

    margin = "0px";
    var rmIndex = player.changing.indexOf(player.hand[slot]);
    player.changing.removeLast();
    toggled[slot]= !toggled[slot];
  }

  query('#${slots[slot]}').style.marginTop=margin;

  if(player.changing.length>0){
    query('#change').style
    ..visibility="visible"
    ..display="inline";
  }
  else{
    query('#change').style
    ..visibility="hidden"
    ..display="none";
  }

  }
}

String updateStatus(Player player, Player computer, PokerEngine game){
  switch(player.status){
    case 0:
      return '<p>Idle<p>';
    case 1:
      return '<p>You have a <b>${player.handValue}</b>. Click on cards you want to change or jump to showdown.</p><p>&nbsp;</p>';
    case 2:
      return '<p>You have a <b>${player.handValue}</b>, your opponent has a <b>${computer.handValue}.</b></p><p>${game.compareHands(player,computer)}</p>';
  }
}