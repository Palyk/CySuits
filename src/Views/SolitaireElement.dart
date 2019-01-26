import 'dart:html';
import 'CardElement.dart';
import '../Controller/EntityManager.dart';
import '../Controller/Logic/SolitaireLogic.dart';


class SolitaireElement {
  EntityManager em;


  DivElement parent;
  //tableus
  List<List<CardElement>> tableuCardList;
  List<List<DivElement>> tableuCardDivList;
  List<DivElement> tableuDivList;
  DivElement tableuDiv;
  
  //pile
  DivElement pileDiv;
  CardElement pile;

  //waste
  List<CardElement> wasteList;
  List<DivElement> wasteDivList;
  DivElement wasteDiv;
  
  //founds
  List<CardElement> foundList;
  List<DivElement> foundDivList;
  DivElement foundDiv;
  
  int cardSelected;
  


  //button
  ButtonElement newGameButton;

  //place all needed elements and variables here. no getters and setters required
  //all sub elements are also here

  SolitaireElement(DivElement parentDiv) {
    //this is your constructor. Make sure to initialize any default values and ALL Element type objects. Get it set up so that something is on the screen and filled with default values.
    //also be sure to add all the Element stuff to the children of this.

    this.parent = parentDiv;
    
    newGameButton = new ButtonElement();
    
    tableuDiv = new DivElement();
    tableuCardList = new List();
    tableuDivList = new List();
    tableuCardDivList = new List();
    for( int i = 0; i < 7; i++){
      tableuDivList.add(new DivElement());
      tableuCardList.add(new List<CardElement>());
      tableuCardDivList.add(new List<DivElement>());
      tableuDiv.children.add(tableuDivList.last);
    }
    
    pileDiv = new DivElement();
    pile = new CardElement(pileDiv);

    foundDiv = new DivElement();
    foundDivList = new List<DivElement>();
    foundList = new List<CardElement>();

    for(int i = 0; i<4; i++ ){
      foundDivList.add(new DivElement());
      foundList.add(new CardElement(foundDivList.last));
      foundList.last.blank = true;
      foundDiv.children.add(foundDivList.last);
    }

    wasteDiv = new DivElement();
    wasteDivList = new List<DivElement>();
    wasteList = new List<CardElement>();

    for(int i = 0; i<3; i++ ){
      wasteDivList.add(new DivElement());
      wasteList.add(new CardElement(wasteDivList.last));
      wasteDiv.children.add(wasteDivList.last);
    }


    parent.children.add(pileDiv);
    parent.children.add(wasteDiv);
    parent.children.add(foundDiv);
    parent.children.add(tableuDiv);
    parent.children.add(newGameButton);

    applyStyle();
  }

  void applyStyle(){
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


      wasteDiv.style.setProperty('position', 'absolute');
      wasteDiv.style.setProperty('width', '200px');
      wasteDiv.style.setProperty('left', '70');
      wasteDiv.style.setProperty('top', '100');


    foundDiv.style.setProperty('position','absolute');
    foundDiv.style.setProperty('width','300px');
    foundDiv.style.setProperty('left','300');
    foundDiv.style.setProperty('top','100');

    newGameButton.style.setProperty('position','absolute');
    newGameButton.style.setProperty('left','10');
    newGameButton.text = 'New Game';
  }

  void render(){
    //this method is called on every tick. This method uses the variables to set attributes of the Elements in this.children


    foundList.forEach((curr) {
      curr.render();
    });

    wasteList.forEach((curr) {
      curr.render();
    });
    for(int i = 0;  i < tableuCardList.length ;i++){
      for(int j = 0;  j <tableuCardList[i].length;j++){
          tableuCardList[i][j].render();
      }
    }
    applyStyle();
  }
}
