import 'dart:html';
import '../../Controller/Renderer.dart';
import '../../Controller/EntityManager.dart';
import '../../Views/CardElement.dart';
import '../../Views/SolitaireElement.dart';

DivElement parent = querySelector('#Soli');

class SolitaireLogic {
  EntityManager em;
  Renderer r;


  SolitaireLogic(EntityManager em, Renderer r) {
    this.em = em;
    this.r = r;
  }
  void run() {

    if (em.solitaire_save == 1){
      return;
    }
      if (em.solitaireState.game_status == 0) {
        em.solitaireState.game_status = 1;
        initGame();
      }
    else if(em.solitaireState.game_status == 1){
     updateRenderables();
    }
    r.solitaireElement.newGameButton.onClick.listen(newGame);



    //VICTORY!!!!
    if (em.solitaireState.foundation.isNotEmpty && em.solitaireState.foundation[0].length == 13
        && em.solitaireState.foundation[1].length == 13
        && em.solitaireState.foundation[2].length == 13
        && em.solitaireState.foundation[3].length == 13) {
      //Have Game Won text
    }
  }


  Event newGame(Event e) {
    if (r.solitaireElement.newGameButton == e.target) {
      r.solitaireElementDiv.remove();
      r.solitaireElementDiv = null;
      r.solitaireElementDiv = new DivElement();
      r.parent.children.add(r.solitaireElementDiv);
      r.solitaireElement = new SolitaireElement(r.solitaireElementDiv);
      initGame();
    }
  }

  void initGame(){
    List<int> deck = new List();
    for( int i = 0; i < 52 ;i++){
      deck.add(i);
    }
    deck.shuffle();
    if(em.solitaireState.foundation.isEmpty){
      em.solitaireState.foundation.add(new List<int>());
      em.solitaireState.foundation.add(new List<int>());
      em.solitaireState.foundation.add(new List<int>());
      em.solitaireState.foundation.add(new List<int>());
    }
    em.solitaireState.foundation[0].clear();
    em.solitaireState.foundation[1].clear();
    em.solitaireState.foundation[2].clear();
    em.solitaireState.foundation[3].clear();

    if(em.solitaireState.tableuUp.isEmpty){
      em.solitaireState.tableuUp.add(new List<int>());
      em.solitaireState.tableuUp.add(new List<int>());
      em.solitaireState.tableuUp.add(new List<int>());
      em.solitaireState.tableuUp.add(new List<int>());
      em.solitaireState.tableuUp.add(new List<int>());
      em.solitaireState.tableuUp.add(new List<int>());
      em.solitaireState.tableuUp.add(new List<int>());
    }
    if(em.solitaireState.tableuDown.isEmpty){
      em.solitaireState.tableuDown.add(new List<int>());
      em.solitaireState.tableuDown.add(new List<int>());
      em.solitaireState.tableuDown.add(new List<int>());
      em.solitaireState.tableuDown.add(new List<int>());
      em.solitaireState.tableuDown.add(new List<int>());
      em.solitaireState.tableuDown.add(new List<int>());
      em.solitaireState.tableuDown.add(new List<int>());
    }
    r.solitaireElement.wasteList[2].cardImage.onClick.listen(handle);
    r.solitaireElement.pile.cardImage.onClick.listen(newWaste);
    r.solitaireElement.foundList[0].cardImage.onClick.listen(handle);
    r.solitaireElement.foundList[1].cardImage.onClick.listen(handle);
    r.solitaireElement.foundList[2].cardImage.onClick.listen(handle);
    r.solitaireElement.foundList[3].cardImage.onClick.listen(handle);

    for(int i = 0; i<7 ;i++){
      em.solitaireState.tableuDown[i].clear();
      em.solitaireState.tableuUp[i].clear();
      for(int j=0;j<i;j++){
        em.solitaireState.tableuDown[i].add(deck.removeLast());
      }
      em.solitaireState.tableuUp[i].add(deck.removeLast());
    }
    em.solitaireState.waste.clear();
    em.solitaireState.stockpile = deck;
    em.solitaireState.game_status = 1;
  }

  void handle(Event e) {
    print('made it');
    if (r.solitaireElement.cardSelected == null) {
      cardSelectTableu(e);
      cardSelectWaste(e);
    }
    else{
      validateRecieve(e);
    }
  }

  void cardSelectFoundation(Event e){
    for(int i =0; i < r.solitaireElement.foundList.length; i++) {
      if (r.solitaireElement.foundList[i].cardImage == e.target) {
        r.solitaireElement.cardSelected = r.solitaireElement.foundList[i].cardCode;
        r.solitaireElement.foundList[i].cardImage.style.setProperty('border-style','solid');
      }
    }
  }
  void cardSelectTableu(Event e){
    for(int i =0; i < r.solitaireElement.tableuCardList.length; i++) {
      for(int j=0; j < r.solitaireElement.tableuCardList[i].length;j++){
        if (r.solitaireElement.tableuCardList[i][j].cardImage == e.target) {
          r.solitaireElement.cardSelected = r.solitaireElement.tableuCardList[i][j].cardCode;
          r.solitaireElement.tableuCardList[i][j].cardImage.style.setProperty('border-style','solid');
        }
      }
    }
  }
  void cardSelectWaste(Event e) {
    for(int i =0; i < r.solitaireElement.wasteList.length; i++) {
      if (r.solitaireElement.wasteList[i].cardImage == e.target) {
        r.solitaireElement.cardSelected = r.solitaireElement.wasteList[i].cardCode;
        r.solitaireElement.wasteList[i].cardImage.style.setProperty('border-style','solid');
      }
    }
  }

  void validateRecieve(Event e){
    for(int i =0 ; i < r.solitaireElement.tableuCardList.length; i++){
      if (em.solitaireState.tableuUp[i].isEmpty == false) {
        for (int j = 0; j < em.solitaireState.tableuUp[i].length; j++) {
          if(r.solitaireElement.cardSelected != null){
            if(isRed(r.solitaireElement.cardSelected)!= isRed(r.solitaireElement.tableuCardList[i].last.cardCode )){
              if(isRed(r.solitaireElement.cardSelected) == true){
                if(r.solitaireElement.cardSelected == r.solitaireElement.tableuCardList[i].last.cardCode + 2 ||
                    r.solitaireElement.cardSelected == r.solitaireElement.tableuCardList[i].last.cardCode + 3){
                  print("1");
                  recieveTableu(e);
                }
              }
              else if(r.solitaireElement.cardSelected == r.solitaireElement.tableuCardList[i].last.cardCode + 1 ||
                  r.solitaireElement.cardSelected == r.solitaireElement.tableuCardList[i].last.cardCode + 2){
                print("2");
                recieveTableu(e);
              }
            }
          }
        }
      }
      if (em.solitaireState.tableuUp[i].isEmpty == true &&
          em.solitaireState.tableuDown[i].isEmpty == true) {
        print("3");
          recieveTableu(e);
      }
    }

    for (int i = 0; i < 4; i++) {
      if (em.solitaireState.foundation[i].isEmpty == true &&
          (r.solitaireElement.cardSelected == 0 ||
              r.solitaireElement.cardSelected == 1 ||
              r.solitaireElement.cardSelected == 2 ||
              r.solitaireElement.cardSelected == 3)) {
        recieveFoundation(e);
        break;
      }
      else if (em.solitaireState.foundation[i].isNotEmpty && em.solitaireState.foundation[i].last + 4 ==
          r.solitaireElement.cardSelected) {
        recieveFoundation(e);
      }
    }

  }

void recieveTableu(Event e){
  for(int i = 0; i < 7; i++){
    for(int j = 0; j < r.solitaireElement.tableuCardList[i].length;j++) {
      if(r.solitaireElement.tableuCardList[i][j].cardImage == e.target){
        for(int x = 0; x < 7; x++){
          for(int y = 0; y < r.solitaireElement.tableuCardList[i].length;y++) {
            if(r.solitaireElement.cardSelected == r.solitaireElement.tableuCardList[x][y].cardCode )
            for(int w =0; w < em.solitaireState.tableuUp[x].length-y; w ++){
              em.solitaireState.tableuUp[i].add(em.solitaireState.tableuUp[x].removeAt(w));
              w--;
            }
          }
        }
      }
    }
    r.solitaireElement.cardSelected == null;
  }
}
void recieveFoundation(Event e) {
  print("Squawk");
  //foundation recieving
  for(int i = 0; i < 4; i++){
    if(r.solitaireElement.foundList[i].cardImage == e.target){
      for(int j = 0; j < 7; j++){
        if(r.solitaireElement.tableuCardList[j].last.cardCode == r.solitaireElement.cardSelected ){
          em.solitaireState.foundation[i].add(r.solitaireElement.cardSelected);
          print(em.solitaireState.tableuUp);
          em.solitaireState.tableuUp[j].removeLast();
          if(em.solitaireState.tableuDown[j].isNotEmpty && em.solitaireState.tableuUp[j].isEmpty){
            em.solitaireState.tableuUp[j].add(em.solitaireState.tableuDown[j].removeLast());
          }
        }

      }
      if(r.solitaireElement.wasteList.last.cardCode == r.solitaireElement.cardSelected) {
        em.solitaireState.foundation[i].add(r.solitaireElement.cardSelected);
        em.solitaireState.waste.removeLast();
      }
    }


  }

  r.solitaireElement.cardSelected = null;
}


//waste is displayed like this: 0 1 2
void newWaste(Event e) {
  print("Squawk");
  while(em.solitaireState.waste.isNotEmpty) {
    em.solitaireState.stockpile.add(em.solitaireState.waste.removeLast());
  }
  for (int i = 0; i < 3 && i < em.solitaireState.stockpile.length; i++) {
    print(i);
    em.solitaireState.waste.add(em.solitaireState.stockpile[0]);
    em.solitaireState.stockpile.removeAt(0);
    print(em.solitaireState.waste);
    print(em.solitaireState.stockpile);
  }
}
//returns true if red, false if black
bool isRed(int x ){
  for(int i =1; i<52; i++){

    if(x == i ){
      return true;
    }
    if(x % 2 == 0){
      i+= 2;
    }
  }
  return false;
}
  void updateRenderables() {
    //Update Foundation

    for(int i=0; i<7;i++){
      if(em.solitaireState.tableuDown[i].isEmpty && em.solitaireState.tableuUp[i].isEmpty){
        if(r.solitaireElement.tableuCardList[i].isEmpty){
          r.solitaireElement.tableuCardDivList[i].add(new DivElement());
          r.solitaireElement.tableuCardList[i].add(new CardElement(r.solitaireElement.tableuCardDivList[i][0]));
          r.solitaireElement.tableuCardList[i][0].blank = true;
          r.solitaireElement.tableuDivList[i].children.add(r.solitaireElement.tableuCardDivList[i].last);
        }else if(r.solitaireElement.tableuCardList[i].length > 1){
          r.solitaireElement.tableuCardList[i].clear();
          r.solitaireElement.tableuCardDivList[i].forEach((curr){
            curr.remove();
          });
          r.solitaireElement.tableuCardDivList[i].clear();
          r.solitaireElement.tableuCardDivList[i].add(new DivElement());
          r.solitaireElement.tableuCardList[i].add(new CardElement(r.solitaireElement.tableuCardDivList[i][0]));
          r.solitaireElement.tableuCardList[i][0].blank = true;
          r.solitaireElement.tableuDivList[i].children.add(r.solitaireElement.tableuCardDivList[i].last);
        }else{
          r.solitaireElement.tableuCardList[i][0].blank = true;
        }
        r.solitaireElement.tableuCardList[i][0].cardImage.onClick.listen(handle);
      }else{
        while(em.solitaireState.tableuUp[i].length + em.solitaireState.tableuDown[i].length < r.solitaireElement.tableuCardList[i].length){
          r.solitaireElement.tableuCardList[i].removeLast();
          r.solitaireElement.tableuCardDivList[i].removeLast().remove();
        }
        while(em.solitaireState.tableuUp[i].length + em.solitaireState.tableuDown[i].length > r.solitaireElement.tableuCardList[i].length){
          r.solitaireElement.tableuCardDivList[i].add(new DivElement());
          r.solitaireElement.tableuCardList[i].add(new CardElement(r.solitaireElement.tableuCardDivList[i].last));
          r.solitaireElement.tableuCardList[i].last.cardImage.onClick.listen(handle);
          r.solitaireElement.tableuDivList[i].children.add(r.solitaireElement.tableuCardDivList[i].last);
        }
        int j;
        for(j=0;j<em.solitaireState.tableuDown[i].length;j++){
          r.solitaireElement.tableuCardList[i][j].cardCode = em.solitaireState.tableuDown[i][j];
          r.solitaireElement.tableuCardList[i][j].hidden = true;
        }
        int k;
        for(k=0;k<em.solitaireState.tableuUp[i].length;k++){
          r.solitaireElement.tableuCardList[i][j+k].cardCode = em.solitaireState.tableuUp[i][k];
          r.solitaireElement.tableuCardList[i][j+k].hidden = false;
        }
      }
    }

    for(int i=0;i<4;i++){
      if(em.solitaireState.foundation[i].isNotEmpty){
        r.solitaireElement.foundList[i].cardCode = em.solitaireState.foundation[i].last;
        r.solitaireElement.foundList[i].hidden = false;
        r.solitaireElement.foundList[i].blank = false;
      }else{
        r.solitaireElement.foundList[i].blank = true;
      }
    }

    if(em.solitaireState.waste.length > 2){
      r.solitaireElement.wasteList[2].cardCode = em.solitaireState.waste[em.solitaireState.waste.length-1];
      r.solitaireElement.wasteList[1].cardCode = em.solitaireState.waste[em.solitaireState.waste.length-2];
      r.solitaireElement.wasteList[0].cardCode = em.solitaireState.waste[em.solitaireState.waste.length-3];
      r.solitaireElement.wasteList[0].blank = false;
      r.solitaireElement.wasteList[1].blank = false;
      r.solitaireElement.wasteList[2].blank = false;
      r.solitaireElement.wasteList[0].hidden = false;
      r.solitaireElement.wasteList[1].hidden = false;
      r.solitaireElement.wasteList[2].hidden = false;
    }else{
      r.solitaireElement.wasteList[0].blank = true;
      r.solitaireElement.wasteList[1].blank = true;
      r.solitaireElement.wasteList[2].blank = true;
    }


    if(em.solitaireState.stockpile.isNotEmpty){
      r.solitaireElement.pile.hidden = true;
    } else {
      r.solitaireElement.pile.blank = true;
    }
  }
}


