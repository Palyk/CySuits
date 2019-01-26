import 'dart:html';
import '../../Views/CardElement.dart';
import '../EntityManager.dart';
import '../Renderer.dart';

class NiLogic {
  EntityManager em;
  Renderer r;

  UILogic(Renderer renderer, EntityManager entityManager) {
    r = renderer;
    em = entityManager;
  }

  void run() {
    
  }
  
  void deepCopy(){
    while(em.gameState.players[0].hand.length < r.niElement.playerHandDivList.length){
      r.niElement.playerHandDivList.last.remove();
      r.niElement.playerHandDivList.removeLast();
      r.niElement.playerHandList.removeLast();
    }
    while(em.gameState.players[1].hand.length < r.niElement.playerFieldDivList.length){
      r.niElement.playerFieldDivList.last.remove();
      r.niElement.playerFieldDivList.removeLast();
      r.niElement.playerFieldList.removeLast();
    }
    while(em.gameState.players[2].hand.length < r.niElement.playerTrapDivList.length){
      r.niElement.playerTrapDivList.last.remove();
      r.niElement.playerTrapDivList.removeLast();
      r.niElement.playerTrapList.removeLast();
    }
    while(em.gameState.players[3].hand.length < r.niElement.enemyHandDivList.length){
      r.niElement.enemyHandDivList.last.remove();
      r.niElement.enemyHandDivList.removeLast();
      r.niElement.enemyHandList.removeLast();
    }
    while(em.gameState.players[4].hand.length < r.niElement.enemyFieldDivList.length){
      r.niElement.enemyFieldDivList.last.remove();
      r.niElement.enemyFieldDivList.removeLast();
      r.niElement.enemyFieldList.removeLast();
    }
    while(em.gameState.players[5].hand.length < r.niElement.enemyTrapDivList.length){
      r.niElement.enemyTrapDivList.last.remove();
      r.niElement.enemyTrapDivList.removeLast();
      r.niElement.enemyTrapList.removeLast();
    }
    while(em.gameState.players[0].hand.length > r.niElement.playerHandDivList.length){
      r.niElement.playerHandDivList.add(new DivElement());
      r.niElement.playerHandList.add(new CardElement(r.niElement.playerHandDivList.last));
    }
    while(em.gameState.players[1].hand.length > r.niElement.playerFieldDivList.length){
      r.niElement.playerFieldDivList.add(new DivElement());
      r.niElement.playerFieldList.add(new CardElement(r.niElement.playerFieldDivList.last));
    }
    while(em.gameState.players[2].hand.length > r.niElement.playerTrapDivList.length){
      r.niElement.playerTrapDivList.add(new DivElement());
      r.niElement.playerTrapList.add(new CardElement(r.niElement.playerTrapDivList.last));
    }
    while(em.gameState.players[3].hand.length > r.niElement.enemyHandDivList.length){
      r.niElement.enemyHandDivList.add(new DivElement());
      r.niElement.enemyHandList.add(new CardElement(r.niElement.enemyHandDivList.last));
    }
    while(em.gameState.players[4].hand.length > r.niElement.enemyFieldDivList.length){
      r.niElement.enemyFieldDivList.add(new DivElement());
      r.niElement.enemyFieldList.add(new CardElement(r.niElement.enemyFieldDivList.last));
    }
    while(em.gameState.players[5].hand.length > r.niElement.enemyTrapDivList.length){
      r.niElement.enemyTrapDivList.add(new DivElement());
      r.niElement.enemyTrapList.add(new CardElement(r.niElement.enemyTrapDivList.last));
    }
    
    int i;
    for(i=0;i<em.gameState.players[0].hand.length;i++){
      r.niElement.playerHandList[i].cardCode = em.gameState.players[0].hand[i];
    }
    for(i=0;i<em.gameState.players[1].hand.length;i++){
      r.niElement.playerFieldList[i].cardCode = em.gameState.players[1].hand[i];
    }
    for(i=0;i<em.gameState.players[2].hand.length;i++){
      r.niElement.playerTrapList[i].hidden = true;
      r.niElement.playerTrapList[i].cardCode = em.gameState.players[2].hand[i];
    }
    for(i=0;i<em.gameState.players[3].hand.length;i++){
      r.niElement.enemyHandList[i].cardCode = em.gameState.players[0].hand[i];
    }
    for(i=0;i<em.gameState.players[4].hand.length;i++){
      r.niElement.enemyFieldList[i].cardCode = em.gameState.players[1].hand[i];
    }
    for(i=0;i<em.gameState.players[5].hand.length;i++){
      r.niElement.enemyTrapList[i].hidden = true;
      r.niElement.enemyTrapList[i].cardCode = em.gameState.players[2].hand[i];
    }
    
    
  }
  //Player
  //Hand 0
  //Field 1
  //Trap 2

  //Enemy
  //Hand 3
  //Field 4
  //Trap 5
  void switchModes(e){

  }
  void useSpell(e){
    for(int i = 0; i < em.gameState.players[0].hand.length; i++){
      if(r.niElement.playerHandList[i].cardImage == e.Target){

      }
    }

  }
  void setTrap(Event e){

  }
  void playTrap(Event e){

  }
  void setMonster(Event e){

  }
  void attack(Event e){

  }
  void draw(e){

  }
  void returnSpellCard() {}
}
