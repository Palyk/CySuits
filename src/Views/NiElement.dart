import 'dart:html';
import 'CardElement.dart';


class NiElement {
  DivElement parent;

  DivElement playerHandDiv;
  List<DivElement> playerHandDivList;
  List<CardElement> playerHandList;
  DivElement playerFieldDiv;
  List<DivElement> playerFieldDivList;
  List<CardElement> playerFieldList;
  DivElement playerTrapDiv;
  List<DivElement> playerTrapDivList;
  List<CardElement> playerTrapList;
  DivElement playerGraveyardDiv;
  CardElement playerGraveyard;
  ImageElement playerPortrait;

  DivElement enemyHandDiv;
  List<DivElement> enemyHandDivList;
  List<CardElement> enemyHandList;
  DivElement enemyFieldDiv;
  List<DivElement> enemyFieldDivList;
  List<CardElement> enemyFieldList;
  DivElement enemyTrapDiv;
  List<DivElement> enemyTrapDivList;
  List<CardElement> enemyTrapList;
  DivElement enemyGraveyardDiv;
  CardElement enemyGraveyard;
  ImageElement enemyPortrait;

  NiElement(DivElement parentDiv) {
    this.parent = parentDiv;
    playerHandDiv = new DivElement();
    playerHandDivList = [];
    playerHandList = [];
    playerFieldDiv = new DivElement();
    playerFieldDivList = [];
    playerFieldList = [];
    playerTrapDiv = new DivElement();
    playerTrapDivList = [];
    playerTrapList = [];
    playerGraveyardDiv = new DivElement();
    playerPortrait = new ImageElement();

    enemyHandDiv = new DivElement();
    enemyHandDivList = [];
    enemyHandList = [];
    enemyFieldDiv = new DivElement();
    enemyFieldDivList = [];
    enemyFieldList = [];
    enemyTrapDiv = new DivElement();
    enemyTrapDivList = [];
    enemyTrapList = [];
    enemyGraveyardDiv = new DivElement();
    enemyPortrait = new ImageElement();
  }
  
  void render(){
    playerHandList.forEach((curr) {
      curr.render();
    });
    playerFieldList.forEach((curr) {
      curr.render();
    });
    playerTrapList.forEach((curr) {
      curr.render();
    });

    enemyHandList.forEach((curr) {
      curr.render();
    });
    enemyFieldList.forEach((curr) {
      curr.render();
    });
    enemyTrapList.forEach((curr) {
      curr.render();
    });
    applyStyle();
  }

  void applyStyle(){
    /*
    pileDiv.setAttribute('id','pile');
    wasteDiv.setAttribute('id','waste');
    foundDiv.setAttribute('id','foundation');
    tableuDiv.setAttribute('id','tableu');

    tableuDiv.style.setProperty('position','absolute');
    tableuDiv.style.setProperty('width','450px');
    tableuDiv.style.setProperty('left','10');
    tableuDiv.style.setProperty('top','300');

    for(int i = 0;i<7;i++){
      tableuDivList[i].style.setProperty('position','absolute');
      tableuDivList[i].style.setProperty('width','50px');
      tableuDivList[i].style.setProperty('left','${i!=0 ? 10 + (i*60): 10}');
      for(int j = 0;j<tableuCardDivList[i].length;j++){
        tableuCardList[i][j].cardImage.style.setProperty('margin-top','-70px');
      }
    }

    pileDiv.style.setProperty('position','absolute');
    pileDiv.style.setProperty('left','10');
    pileDiv.style.setProperty('top','100');

    wasteDiv.style.setProperty('position','absolute');
    wasteDiv.style.setProperty('width','200px');
    wasteDiv.style.setProperty('left','70');
    wasteDiv.style.setProperty('top','100');

    foundDiv.style.setProperty('position','absolute');
    foundDiv.style.setProperty('width','300px');
    foundDiv.style.setProperty('left','300');
    foundDiv.style.setProperty('top','100');

    newGameButton.style.setProperty('position','absolute');
    newGameButton.style.setProperty('left','10');
    newGameButton.text = 'New Game';
    */
  }
}
