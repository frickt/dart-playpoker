
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




showCards(Player player){
  String prefix;
  if(player.human){
    prefix='h';
  }
  else{
    prefix='c';
  }
  List slots = ['1','2','3','4','5'];
  for (var i = 0; i<5; i++){
    query('#$prefix${slots[i]}').style
    ..backgroundImage='url(${player.hand[i].cardImage()})'
    ..width='71px'
        ..height='96px';
  }

}